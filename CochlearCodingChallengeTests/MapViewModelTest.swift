//
//  MapViewModelTest.swift
//  CochlearCodingChallengeTests
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import XCTest
@testable import CochlearCodingChallenge

struct APIClientMoc: API {
    func fetchLocations(onComplete: @escaping ([Location]) -> Void) {
       let data = loadJsonFile(name: "data", withExtension: "json")!
        let decoder = JSONDecoder.locations
        let jsonObject = try! decoder.decode(LocationsDataObject.self, from: data)
        onComplete(jsonObject.locations)
    }
}

class MapViewModelTest: XCTestCase {

    let apiClient = APIClientMoc()
    var dataStorage = LocationStorageMoc()
    
    override func setUp() {
        dataStorage.removeAll()
    }
    
    override func tearDown() {
        dataStorage.removeAll()
    }
    
    func testViewModelFetch() {
        
        let viewModel = MapViewModel(apiClient: apiClient, storage: dataStorage) {[weak self] locations in
            print("onComplete")
            XCTAssertEqual(locations.count, 5)
            let locations = self!.dataStorage.locations
            XCTAssertEqual(locations.count, 5)
        }
        
        viewModel.fetchLocations()
        
    }
    
    
    func testExistingLocations() {
        let location1 = Location(name: "test 1", lat: 1200, lng: 321, note: nil, locationType: .user)
        let location2 = Location(name: "test 2", lat: 1210, lng: 321, note: nil, locationType: .user)
        dataStorage.locations = [location1, location2]
        
        let viewModel = MapViewModel(apiClient: apiClient, storage: dataStorage) {[weak self] locations in
            print("onComplete")
            XCTAssertEqual(locations.count, 2)
            let locations = self!.dataStorage.locations
            XCTAssertEqual(locations.count, 2)
        }
        
        viewModel.fetchLocations()
    }
    

}
