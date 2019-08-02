//
//  MapViewModel.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

//MapViewModel for the Map view controller
class MapViewModel {
    
    var apiClient: API
    var storage: LocationsStorage
    var onComplete: ([Location]) -> Void
    
    var locations: [Location] {
        return storage.locations
    }
    
    func add(_ location: Location) {
        storage.add(location)
    }
    
    init(apiClient: API, storage: LocationsStorage, onComplete: @escaping ([Location])-> Void) {
        self.apiClient = apiClient
        self.storage = storage
        self.onComplete = onComplete
    }
    
    // return existing locations, if empty fetch it from the server
    func fetchLocations() {
        
        guard storage.locations.isEmpty else {
            onComplete(storage.locations)
            return
        }
        
        apiClient.fetchLocations { [weak self] in
            guard let self = self else { return }
            self.storage.locations = $0
            self.onComplete($0)
        }
    }
}
