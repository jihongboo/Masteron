//
//  Instance.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.23.
//

import Foundation
import BetterCodable

struct Instance: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let thumbnail: URL
    let info: Info
    @LosslessValue var users: Int
    @LosslessValue var statuses: Int
    let version: String?
    let ipv6: Bool
    let httpsScore: Int?
    let httpsRank: String?
    let obsScore: Int
    let obsRank: String?
    let updatedAt: Date
    let dead: Bool
    let openRegistrations: Bool
    let email: URL
    let admin: String?
    
    struct Info: Decodable, Hashable {
        let shortDescription: String?
        let topic: String?
        let languages: [String]
        let otherLanguagesAccepted: Bool
        let prohibitedContent: [String]
        let categories: [String]
        let fullDescription: String?
    }
}
