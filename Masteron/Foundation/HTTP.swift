//
//  HTTP.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.18.
//

import Foundation

import Foundation

public struct HTTP {
    public enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    private static let urlSession = URLSession.shared
    
    public static func request(method: Method, url: URL, parameters: [String: AnyHashable]? = nil, header: [String: String]? = nil) async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        header?.forEach({ key, value in
            request.setValue(value, forHTTPHeaderField: key)
        })
        if method == .post, let parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return try await urlSession.data(for: request)
    }
    
//    public static func get<T: Decodable>(url: URL, header: [String: String]? = nil) async throws -> T {
//        let data = try await request(method: .get, url: url, header: header)
//        return try JSON.decode(data: data)
//    }
//    
//    public static func post<T: Decodable>(url: URL, parameters: [String: AnyHashable]? = nil) async throws -> T {
//        let data = try await request(method: .post, url: url, parameters: parameters)
//        return try JSON.decode(data: data)
//    }
}
