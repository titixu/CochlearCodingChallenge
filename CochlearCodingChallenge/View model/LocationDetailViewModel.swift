//
//  LocationDetailViewModel.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

class LocationDetailViewModel {
    // use to storage location when user changed the note or the name of the location
    var storage: LocationsStorage
    // the location for display or editing
    var location: Location
    
    var name: String {
        return location.name
    }
    
    var note: String? {
        return location.note
    }
    
    init(storage: LocationsStorage, location: Location) {
        self.storage = storage
        self.location = location
    }
    
    func updateName(_ name: String?) {
        guard let name = name,
            !name.isEmpty else {
                // empty string name will cause annotation callout disabled assign default text for it
                location.name = "Unknown"
                return
        }
        location.name = name
    }
    
    func updateNote(_ note: String?) {
        location.note = note
    }
    
    // only save the changes when user click save button
    func save() {
        var locations = storage.locations
        guard let index = locations.firstIndex (where: {
            $0 == location
        }) else { return }
        locations[index] = location
        storage.locations = locations
    }
}
