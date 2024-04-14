//
//  Account.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.15.
//

import Foundation

struct Account: Codable, Hashable, Identifiable {
    let id: String
    let displayName: String
    let acct: String
    let avatar: URL
    let header: URL
    let url: URL
    let note: AttributedString
    let followersCount: Int
    let followingCount: Int
    let statusesCount: Int
    let fields: [AccountField]
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case acct
        case avatar
        case header
        case url
        case note
        case followersCount
        case followingCount
        case statusesCount
        case fields
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        displayName = try values.decode(String.self, forKey: .displayName)
        acct = try values.decode(String.self, forKey: .acct)
        avatar = try values.decode(URL.self, forKey: .avatar)
        header = try values.decode(URL.self, forKey: .header)
        url = try values.decode(URL.self, forKey: .url)
        followersCount = try values.decode(Int.self, forKey: .followersCount)
        followingCount = try values.decode(Int.self, forKey: .followingCount)
        statusesCount = try values.decode(Int.self, forKey: .statusesCount)
        fields = try values.decode([AccountField].self, forKey: .fields)
        
        let html = try values.decode(String.self, forKey: .note)
        note = AttributedString(html: html)
    }
    
    // Equatable
    static func == (lhs: Account, rhs: Account) -> Bool {
        lhs.id == rhs.id
    }
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct AccountField: Codable {
    let name: String
    let value: String
}
