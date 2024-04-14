//
//  JSON.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.18.
//

import Foundation

public struct JSON {
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let createdAtDateFormatter = DateFormatter()
        createdAtDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        decoder.dateDecodingStrategy = .formatted(createdAtDateFormatter)
        return decoder
    }()
    
    private static let encoder: JSONEncoder = JSONEncoder()
    
    static func decode<T: Decodable>(data: Data) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
    
    static func encode(value: Encodable) throws -> Data {
        try encoder.encode(value)
    }
}
