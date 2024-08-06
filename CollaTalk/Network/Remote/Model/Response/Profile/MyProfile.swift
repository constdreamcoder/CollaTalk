//
//  MyProfile.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/3/24.
//

import Foundation

struct MyProfile: Decodable {
    var userId: String
    var email: String
    var nickname: String
    var profileImage: String?
    var phone: String?
    var provider: SocialLoginLogo?
    var sesacCoin: Int
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
        case phone
        case provider
        case sesacCoin
        case createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decode(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        let provider = try container.decodeIfPresent(String.self, forKey: .provider) ?? ""
        self.provider = SocialLoginLogo(rawValue: provider)
        self.sesacCoin = try container.decode(Int.self, forKey: .sesacCoin)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}
