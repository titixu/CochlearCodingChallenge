//
//  LocationAnnotation.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import MapKit

class LocationAnnotation: MKPointAnnotation {
    var location: Location
    init(location: Location) {
        self.location = location
        super.init()
        title = location.name
        coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lng)
    }
}

