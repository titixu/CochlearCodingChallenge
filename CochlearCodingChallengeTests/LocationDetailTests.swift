//
//  LocationDetailTests.swift
//  CochlearCodingChallengeTests
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import XCTest
@testable import CochlearCodingChallenge

class LocationDetailTests: XCTestCase {
    let locationStorageMoc = LocationStorageMoc()

    override func setUp() {
        let location1 = Location(name: "test1", lat: 1, lng: 321, note: nil, locationType: .user)
        let location2 = Location(name: "test2", lat: 2, lng: 321, note: nil, locationType: .user)
        let location3 = Location(name: "test3", lat: 3, lng: 321, note: nil, locationType: .user)
        let location4 = Location(name: "test4", lat: 4, lng: 321, note: nil, locationType: .user)
        let locations = [location1, location2, location3, location4]
        
        locationStorageMoc.locations = locations
        
    }
    
    func testViewModel() {
        let location = Location(name: "test3", lat: 3, lng: 321, note: nil, locationType: .user)
        
        let viewModel = LocationDetailViewModel(storage: locationStorageMoc, location: location)
        
        viewModel.updateName("updated name")
        viewModel.updateNote("updated note")
        viewModel.save()
        XCTAssertEqual(viewModel.location.name, "updated name")
        XCTAssertEqual(viewModel.location.note, "updated note")
        XCTAssertEqual(viewModel.location.locationType, .user)
        XCTAssertEqual(viewModel.location.lat, 3)
        XCTAssertEqual(viewModel.location.lng, 321)
        
        let locationUpdated = locationStorageMoc.locations[2]
        XCTAssertEqual(locationUpdated, location)
        XCTAssertEqual(locationUpdated.name, "updated name")
        XCTAssertEqual(locationUpdated.note, "updated note")
    }
    
    override func tearDown() {
        locationStorageMoc.locations.removeAll()
    }


}
