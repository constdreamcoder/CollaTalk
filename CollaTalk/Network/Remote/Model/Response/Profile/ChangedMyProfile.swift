//
//  ChangedMyProfile.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/4/24.
//

import Foundation

struct ChangedMyProfile: Decodable {
    let userId: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let provider: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
        case phone
        case provider
        case createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decode(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        self.provider = try container.decodeIfPresent(String.self, forKey: .provider)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}
