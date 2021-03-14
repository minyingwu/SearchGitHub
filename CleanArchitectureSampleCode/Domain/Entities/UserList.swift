//
//  UserList.swift
//  CleanArchitectureSampleCode
//
//  Created by Victor on 2021/3/11.
//

import Foundation

struct UserList: Codable {
    let totalCount: Int
    let items: [UserItem]
    
    var nextPath: String?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decodeWrapper(key: .totalCount, defaultValue: 0)
        items = try container.decodeWrapper(key: .items, defaultValue: [])
    }
}

struct UserItem: Codable {
    let login: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try container.decodeWrapper(key: .login, defaultValue: "")
        avatarURL = try container.decodeWrapper(key: .avatarURL, defaultValue: "")
    }
}
