//
//  API.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.18.
//

import Foundation

struct API {
    static let instances = API(host: "instances.social", mainPath: "/api/1.0/instances", authorization: API.instancesAuthorization)
    static let mastodon: API = {
        let host = UserDefaults.standard.string(forKey: "MastodonHost") ?? "mastodon.social"
        return API(host: host, mainPath: "/api/v1", authorization: nil)
    }()
    static let mastodonOAuth = API(host: "mastodon.social", mainPath: "/oauth/token", authorization: nil)

    private static let instancesAuthorization = "Bearer 4T8I27w8jcwXmtCHnYm0GTC4pHorR7jfhV1eCefgVRnlZYDkibqCEYZU31kRAYbakCGFG1Ii2x2xd8kdmCi45b0Wf55i7ArYHzpfsu8kQzdm1af3oXUDIiwM2hiJQJl3"
    private let host: String
    private let mainPath: String
    private let authorization: String?
    
    func request<T: Decodable>(method: HTTP.Method, path: String, parameters: [String: AnyHashable]? = nil) async throws -> T {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "\(mainPath)\(path)"
        if method == .get {
            urlComponents.queryItems = parameters?.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
        }
        
        if let authorization = UserDefaults.standard.string(forKey: "Authorization") {
            let response = try await HTTP.request(method: method,
                                                  url: urlComponents.url!,
                                                  parameters: parameters,
                                                  header: ["Authorization": authorization])
            return try API.decode(response: response)
        } else {
            throw HTTPError.authentication
        }
    }
    
    private static func decode<T: Decodable>(response: (Data, URLResponse)) throws -> T {
        let (data, response) = response
        if let statusCode = (response as? HTTPURLResponse)?.statusCode,
           let error = HTTPError(rawValue: statusCode) {
            throw error
        }
        
        return try JSON.decode(data: data)
    }
}

enum HTTPError: Int, Error {
    case authentication = 401
}

extension HTTPError: ContentUnavailable {
    var icon: String? { "person.circle" }
    var title: String? { NSLocalizedString("Please Login", comment: "") }
    var description: String? { NSLocalizedString("You must be logged in to access this page", comment: "") }
    var buttonTitle: String? { NSLocalizedString("Login", comment: "") }
}
