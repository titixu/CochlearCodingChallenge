//
//  Location.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

// Root level object from the API payload
struct LocationsDataObject: Codable {
    var locations: [Location]
    var updated: Date
}

// Type of the location, neither default from the API payload or added by user
enum LocationType: String, Codable {
    case `default` // location provided form the api server
    case user // user added location
}

// Location store all the data need for a location
struct Location: Codable {
    var name: String
    var lat: Double
    var lng: Double
    var note: String?
    
    // Assumption: there is no dumplicated location-object in a coordinate
    var id: String {
        return "\(lat)\(lng)"
    }
    
    private var type: LocationType?
    
    var locationType: LocationType {
        get {
            return type ?? .default
        }
        set {
            type = newValue
        }
    }
    
    init(name: String = "Unknow",
         lat: Double,
         lng: Double,
         note: String? = nil,
         locationType: LocationType? = .user) {
        self.name = name
        self.lat = lat
        self.lng = lng
        self.note = note
        self.type = locationType
    }
}

// use this to identify location from the storage
extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}
