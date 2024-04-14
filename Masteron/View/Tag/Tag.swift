//
//  Tag.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.15.
//

import Foundation

struct Tag: Codable, Identifiable, Hashable {
    var id: String { name }
    
    let name: String
    let url: URL
    let history: [TagHistory]
    let totalUses: Int
    let totalAccounts: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case history
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        url = try values.decode(URL.self, forKey: .url)
        history = try values.decode([TagHistory].self, forKey: .history)
        totalUses = history.reduce(0) { $0 + $1.uses }
        totalAccounts = history.reduce(0) { $0 + $1.accounts }
    }
    
    // Equatable
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.name == rhs.name
    }
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct TagHistory: Codable, Identifiable {
    var id: Date { day }
    
    let day: Date
    let accounts: Int
    let uses: Int
    
    enum CodingKeys: String, CodingKey {
        case day
        case accounts
        case uses
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let dayString = try values.decode(String.self, forKey: .day)
        let dayInt = Double(dayString)!
        day = Date(timeIntervalSince1970: dayInt)
        
        let accountsString = try values.decode(String.self, forKey: .accounts)
        accounts = Int(accountsString)!
        
        let usesString = try values.decode(String.self, forKey: .uses)
        uses = Int(usesString)!
    }
}
