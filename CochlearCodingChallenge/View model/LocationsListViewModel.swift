//
//  LocationsListViewModel.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

// use to calculate the distant from a location
protocol DistantCalculator {
    func distant(from location: Location) -> Double?
}

class LocationsListViewModel {
    var distantCalculator: DistantCalculator
    var storage: LocationsStorage
    var locationDetails = [LocationDetail]()
    
    init(distantCalculator: DistantCalculator, storage: LocationsStorage) {
        self.distantCalculator = distantCalculator
        self.storage = storage
        // Map the locations from the storage into location detail object
        // sort it by distant
        locationDetails = storage.locations.map {
            LocationDetail(location: $0, distant: distantCalculator.distant(from: $0))
            }.sorted {
                $0.distant ?? 0 < $1.distant ?? 0
        }
    }
    
    // location name
    func title(_ indexPath: IndexPath) -> String {
        return locationDetails[indexPath.row].location.name
    }
    
    // location distant from user current location
    func subTitle(_ indexPath: IndexPath) -> String? {
        if let distant = locationDetails[indexPath.row].distant {
            switch distant {
            case let meteter where meteter < 1000.0:
                return "\(Int(meteter)) \(Int(meteter) == 1 ? "meter" : "meters") away from you"
            case let km where km >= 1000.0:
                return "\(Int(km / 1000.0)) \(Int(km / 1000.0) == 1 ? "kilometre" : "kilometres") away from you"
            default:
                return "Distance unavailble"
            }
        } else {
            return "Distance unavailble"
        }
    }
    
    func location(_ indexPath: IndexPath) -> Location {
        return locationDetails[indexPath.row].location
    }
}
