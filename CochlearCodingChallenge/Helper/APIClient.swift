//
//  APIClient.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

// Only need one api function call for this project
protocol API {
    func fetchLocations(onComplete: @escaping ([Location]) -> Void)
}

struct APIClient: API {
    
    func fetchLocations(onComplete: @escaping ([Location]) -> Void) {
        let locationURL = "https://s3-ap-southeast-2.amazonaws.com/com-cochlear-sabretooth-takehometest/locations.json"
        URLSession.shared.dataTask(with: URL(string: locationURL)!) { (data, responds, error) in
            guard let data = data else {
                onComplete([])
                return;
            }
            
            guard let jsonObject = try? JSONDecoder.locations.decode(LocationsDataObject.self, from: data) else {
                onComplete([])
                return;
            }
            
            onComplete(jsonObject.locations)
            }.resume()
    }
}
