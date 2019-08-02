//
//  Decoder.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

// the date formatter for decoding date string from the api payload
extension DateFormatter {
    static var json: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }
}

extension JSONDecoder {
    static var locations: JSONDecoder {
        let decoder = JSONDecoder()
        // auto convert date string into Date object
        decoder.dateDecodingStrategy = .formatted(DateFormatter.json)
        return decoder
        
    }
}
