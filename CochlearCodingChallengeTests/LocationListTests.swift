//
//  LocationListTests.swift
//  CochlearCodingChallengeTests
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import XCTest
@testable import CochlearCodingChallenge

class DistantCalculatorMoc: DistantCalculator {
    func distant(from location: Location) -> Double? {
        return 100
    }
}

// a Moc distant calculator alway return nil distant
// testing location when user current location is missing
class DistantCalculatorNilMoc: DistantCalculator {
    func distant(from location: Location) -> Double? {
        return nil
    }
}

class LocationListTests: XCTestCase {
    
    let locationStorageMoc = LocationStorageMoc()
    
    override func setUp() {
        let location1 = Location(name: "test1", lat: 1, lng: 321, note: nil, locationType: .user)
        let location2 = Location(name: "test2", lat: 2, lng: 321, note: nil, locationType: .user)
        let location3 = Location(name: "test3", lat: 3, lng: 321, note: nil, locationType: .user)
        let location4 = Location(name: "test4", lat: 4, lng: 321, note: nil, locationType: .user)
        
        locationStorageMoc.locations = [location1, location2, location3, location4]
    }
    
    override func tearDown() {
        locationStorageMoc.locations.removeAll()
    }
    
    func testDistant() {
        let viewModel = LocationsListViewModel(distantCalculator: DistantCalculatorMoc(), storage: locationStorageMoc)
        XCTAssertEqual(viewModel.locationDetails.count, 4)
        XCTAssertEqual(viewModel.locationDetails[0].distant, 100)
        
        let indexPath = IndexPath(row: 3, section: 0)
        XCTAssertEqual(viewModel.title(indexPath), "test4")
        XCTAssertEqual(viewModel.subTitle(indexPath), "100 meters away from you")
        
        let viewModel2 = LocationsListViewModel(distantCalculator: DistantCalculatorNilMoc(), storage: locationStorageMoc)
        XCTAssertEqual(viewModel2.locationDetails.count, 4)
        XCTAssertNil(viewModel2.locationDetails[0].distant)
        XCTAssertEqual(viewModel2.title(indexPath), "test4")
        XCTAssertEqual(viewModel2.subTitle(indexPath), "Distance unavailble")
    }
    
}
