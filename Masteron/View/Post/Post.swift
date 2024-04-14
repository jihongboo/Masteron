//
//  Timeline.swift
//  Masteron
//
//  Created by 纪洪波 on 2024.04.14.
//

import Foundation

struct Post: Codable, Identifiable, Hashable {
    let id: String
    let createdAt: Date
    let content: AttributedString
    let account: Account
    let url: URL
    let mediaAttachments: [Media]
    let favourited: Bool
    let favouritesCount: Int
    let reblogged: Bool
    let reblogsCount: Int
    let repliesCount: Int
    let bookmarked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case content
        case account
        case url
        case mediaAttachments
        case favourited
        case favouritesCount
        case reblogged
        case reblogsCount
        case repliesCount
        case bookmarked
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        account = try values.decode(Account.self, forKey: .account)
        url = try values.decode(URL.self, forKey: .url)
        mediaAttachments = try values.decode([Media].self, forKey: .mediaAttachments)
        favourited = (try? values.decode(Bool.self, forKey: .favourited)) ?? false
        favouritesCount = try values.decode(Int.self, forKey: .favouritesCount)
        reblogged = (try? values.decode(Bool.self, forKey: .reblogged)) ?? false
        reblogsCount = try values.decode(Int.self, forKey: .reblogsCount)
        repliesCount = try values.decode(Int.self, forKey: .repliesCount)
        bookmarked = (try? values.decode(Bool.self, forKey: .bookmarked)) ?? false

        let html = try values.decode(String.self, forKey: .content)
        content = AttributedString(html: html)
    }
    
    // Equatable
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    
    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Media: Codable, Identifiable {
    let id: String
    let type: MediaType?
    let url: URL
    let previewUrl: URL
    let description: String?
    let meta: MediaMeta
}

enum MediaType: String, Codable {
    case image
    case video
    case gifv
}

struct MediaMeta: Codable {
    let original: MediaSize
    let small: MediaSize
}

struct MediaSize: Codable {
    let width: Int
    let height: Int
    let ratio: Double
    
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case ratio
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        ratio = Double(width) / Double(height)
    }
}
