//
//  MapViewController.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

fileprivate let annotationViewIdentifier = "annotationViewIdentifier"

class MapViewController: UIViewController {
    
    let mapView = MKMapView(frame: .zero)
    
    let locationManager = CLLocationManager()
    let regionInMeters = 2000.0 // init show 2km range
    
    // keep tracking of user newly added annotation
    // this is for showing the callout on add
    var newlyAddedAnnotation: LocationAnnotation? = nil
    
    lazy var viewModel: MapViewModel = {
        MapViewModel(apiClient: APIClient(), storage: UserDefaults.standard, onComplete: { locations in
            DispatchQueue.main.async {
                self.displayLocations(locations)
            }
        })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Locations"
        
        // show a list button for user to go to the list view of locations
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(listButtonTapped))
        
        // Add map view
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.frame = view.bounds
        
        mapView.delegate = self
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: annotationViewIdentifier)
        checkLocationServices()
        
        // a long press gesture for user to add their own location mark
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress(sender:)))
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // update the annotation every time the map appears
        // it is ok since it is very fast for such a small locations data
        viewModel.fetchLocations()
    }
    
    @objc private func listButtonTapped() {
        let locationsListViewModel = LocationsListViewModel(distantCalculator: locationManager, storage: viewModel.storage)
        let viewController = LocationsListTableViewController(viewModel: locationsListViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func longPress(sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            var location = Location(lat: coordinate.latitude,
                                    lng: coordinate.longitude)
            
            let geo = CLGeocoder()
            geo.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (marks, error) in
                if let mark = marks?.first,
                    let name =
                        mark.thoroughfare ??
                        mark.subLocality ??
                        mark.locality ??
                        mark.name ??
                        mark.ocean {
                    location.name = name
                }
                let anno = LocationAnnotation(location: location)
                self.newlyAddedAnnotation = anno
                self.mapView.addAnnotation(anno)
                self.viewModel.add(location)
            }
        default:
            break
        }
        
    }
}

// MARK: - Annotation
extension MapViewController: MKMapViewDelegate {
    
    private var removeTitle: String {
        return "Remove"
    }
    
    func displayLocations(_ locations: [Location]) {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = generateAnnotations(locations)
        mapView.addAnnotations(annotations)
    }
    
    func generateAnnotations(_ locations: [Location]) -> [LocationAnnotation] {
        return locations.map { (location) -> LocationAnnotation in
            return LocationAnnotation(location: location)
        }
    }
    
    // delegate
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let anno = view.annotation as? LocationAnnotation,
        let button = control as? UIButton else { return }
        
        if button.buttonType == .infoDark {
            let locationViewModel = LocationDetailViewModel(storage: viewModel.storage, location: anno.location)
            let viewController = LocationDetailViewController(viewModel: locationViewModel)
            navigationController?.pushViewController(viewController, animated: true)
        } else if button.title(for: .normal) == removeTitle {
            viewModel.remove(anno.location)
            mapView.removeAnnotation(anno)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let anno = annotation as? LocationAnnotation,
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewIdentifier, for: anno) as? MKPinAnnotationView
            else {
                // let system to handle other annotations such as the blue dot
                return nil
        }
        view.canShowCallout = true
        view.animatesDrop = true
        
        view.leftCalloutAccessoryView = UIButton(type: .infoDark)
        
        let removeButton = UIButton(type: .roundedRect)
        removeButton.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: view.bounds.height)
        removeButton.setTitle(removeTitle, for: .normal)
        view.rightCalloutAccessoryView = removeButton
        return view
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        guard let anno = newlyAddedAnnotation,
            let lastAnno = views.last?.annotation as? LocationAnnotation else { return }
        defer { newlyAddedAnnotation = nil }
        
        if lastAnno.location == anno.location {
            views.last?.setSelected(true, animated: false)
        }
    }
}

// MARK: - Core Location
extension MapViewController: CLLocationManagerDelegate {
    
    // check device local service on/off
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorizationState()
        } else {
            // show GPS is off alert
            let alert = UIAlertController(title: "GPS is off", message: "Please turn on GPS", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        // required the best accuracy to calculate the distance between user and the locations
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // make sure the app has correct authorization
    func checkLocationAuthorizationState() {
        switch CLLocationManager.authorizationStatus() {
            // the app only require authorized when in use
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerMapViewOnUserLocation()
            locationManager.startUpdatingLocation()
            
            // user manually denied the location access
        case .denied:
            let alert = UIAlertController(title: "Location access denied", message: "Allow location access from the system settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            // init state, starting request the permission
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
            // Location access may get restricted, for example parental control
        case .restricted:
            let alert = UIAlertController(title: "Location access restricted", message: "Unrestricte location access from the system settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            // no need for the background access
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func centerMapViewOnUserLocation() {
        guard let location = locationManager.location?.coordinate else {
            return
        }
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        
    }
    
    // MARK: - delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorizationState()
    }
}
