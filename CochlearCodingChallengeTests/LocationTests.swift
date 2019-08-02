//
//  LocationTests.swift
//  LocationTests
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import XCTest
@testable import CochlearCodingChallenge

// load a file from the test bundle
func loadJsonFile(name: String, withExtension: String) -> Data? {
    let bundle = Bundle(for: LocationTests.self)
    let url = bundle.url(forResource: name, withExtension: withExtension)
    return try? Data(contentsOf: url!)
}

class LocationTests: XCTestCase {

    // it is ok to use force unwarp in Unit Test
    // we want tests to crash if anything goes wrong
    private var data: Data!
    private var locations: [Location] = []
    private var decoder: JSONDecoder!

    override func setUp() {
        data = loadJsonFile(name: "data", withExtension: "json")!
        decoder = JSONDecoder.locations
        let jsonObject = try! decoder.decode(LocationsDataObject.self, from: data)
        locations = jsonObject.locations
    }

    override func tearDown() {
        locations.removeAll()
    }

    func testLocations() {
        // test total number
        XCTAssertEqual(locations.count, 5, "Should be 5 locations")
        
        // test first location
        let first = locations.first!
        XCTAssertEqual(first.name, "Milsons Point")
        XCTAssertEqual(first.lat, -33.850750)
        XCTAssertEqual(first.lng, 151.212519)
        XCTAssertEqual(first.locationType, .default)
        
        // test last location
        let last = locations.last!
        XCTAssertEqual(last.name, "Darling Harbour")
        XCTAssertEqual(last.lat, -33.873379)
        XCTAssertEqual(last.lng, 151.200940)
        XCTAssertEqual(first.locationType, .default)
    }
    
    func testLocationEquatable() {
        let location1 = Location(name: "test1", lat: 123, lng: 321, note: nil, locationType: .user)
        let location2 = Location(name: "test2", lat: 123, lng: 321, note: nil, locationType: .default)
        
        XCTAssertEqual(location1, location2)
        
        let location3 = Location(name: "test", lat: 123, lng: 321, note: nil, locationType: .user)
        let location4 = Location(name: "test", lat: 1231, lng: 321, note: nil, locationType: .user)
        
        XCTAssertNotEqual(location3, location4)
        
    }
    
}

// Moc the storage to use in-memory storage
class LocationStorageMoc: LocationsStorage {
    func remove(_ location: Location) {
        locations.removeAll {
            $0 == location
        }
    }
    
    var locations: [Location] = []
    
    func removeAll() {
        locations.removeAll()
    }
    
    func add(_ location: Location) {
        locations.append(location)
    }
    
}

class storageTests: XCTestCase {
    
    // Storages Teste
    func testStorage() {
        let locationsStorage: LocationsStorage = LocationStorageMoc()
        
        // test remove all location
        locationsStorage.removeAll()
        var locations = locationsStorage.locations
        XCTAssertEqual(locations.count, 0)
        
        // test adding a location
        
        let location1 = Location(name: "Test1", lat: 12345, lng: -12345, note: "Test note", locationType: .user)
        let location2 = Location(name: "test2", lat: 2, lng: 321, note: nil, locationType: .user)
        let location3 = Location(name: "test3", lat: 3, lng: 321, note: nil, locationType: .user)
        let location4 = Location(name: "test4", lat: 4, lng: 321, note: nil, locationType: .user)

        
        locationsStorage.add(location1)
        locations = locationsStorage.locations
        XCTAssertEqual(locations.count, 1)
        XCTAssertEqual(locations.first!.name, "Test1")
        XCTAssertEqual(locations.first!.lat, 12345)
        XCTAssertEqual(locations.first!.lng, -12345)
        XCTAssertEqual(locations.first!.note, "Test note")
        XCTAssertEqual(locations.first!.locationType, .user)
        
        locationsStorage.add(location2)
        locationsStorage.add(location3)
        locationsStorage.add(location4)
        XCTAssertEqual(locationsStorage.locations.count, 4)
        
        let locationToRemove = Location(name: "test4", lat: 4, lng: 321, note: nil, locationType: .user)
        locationsStorage.remove(locationToRemove)
        XCTAssertEqual(locationsStorage.locations.count, 3)
        
        let last = locationsStorage.locations.last!
        XCTAssertEqual(last.name, "test3")
        XCTAssertEqual(last.lat, 3)
        XCTAssertEqual(last.lng, 321)
        XCTAssertEqual(last.note, nil)
        XCTAssertEqual(last.locationType, .user)
    }
    
}
