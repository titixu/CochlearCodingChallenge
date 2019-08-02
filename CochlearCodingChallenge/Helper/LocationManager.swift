//
//  LocationManager.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import CoreLocation

extension CLLocationManager: DistantCalculator {
    func distant(from: Location) -> Double? {
        let clLocation = CLLocation(latitude: from.lat, longitude: from.lng)
        guard let currentLocation = location else { return nil }
        return currentLocation.distance(from: clLocation)
    }
}
