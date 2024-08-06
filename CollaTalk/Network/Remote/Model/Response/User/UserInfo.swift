//
//  UserInfo.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

struct UserInfo: Codable {
    var userId: String
    var email: String
    var nickname: String
    var profileImage: String?
    var phone: String?
    var provider: SocialLoginLogo?
    var createdAt: String
    var token: Token
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
        case phone
        case provider
        case createdAt
        case token
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decode(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
        let provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.provider = SocialLoginLogo(rawValue: provider)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.token = try container.decode(Token.self, forKey: .token)
    }
}

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
}
