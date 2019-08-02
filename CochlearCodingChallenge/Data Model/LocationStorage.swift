//
//  LocationStorage.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

// LocationsStorage protocol for location storage
protocol LocationsStorage {
    // get or set the locations in the storage,
    // setting the locations will replace all locations in the storage
    var locations: [Location] { get set }
    // Remove all locations
    func removeAll() -> Void
    // append a location into the storage
    func add(_ location: Location)
    
    func remove(_ location: Location)
}

// Use UserDefaults as location storage for this project
extension UserDefaults: LocationsStorage {
    
    private var key: String {
        return "LocationsStorageKey"
    }
    
    var locations: [Location] {
        get {
            // decode the data object into Location array, return empty array if nil
            guard let jsonData = self.object(forKey: key) as? Data else { return [] }
            return (try? JSONDecoder().decode([Location].self, from: jsonData)) ?? []
        }
        set {
            save(newValue)
        }
    }
    
    // remove all locations
    func removeAll() {
        removeObject(forKey: key)
    }
    
    func add(_ location: Location) {
        var updatedLocations = locations
        updatedLocations.append(location)
        save(updatedLocations)
    }
    
    func remove(_ location: Location) {
        var updatedLocations = locations
        updatedLocations.removeAll {
            $0 == location
        }
        save(updatedLocations)
    }
    
    func save(_ locations: [Location]) {
        guard let data = try? JSONEncoder().encode(locations) else {
            fatalError("fail to convert locations into data")
        }
        set(data, forKey: key)
        synchronize()
    }
}
