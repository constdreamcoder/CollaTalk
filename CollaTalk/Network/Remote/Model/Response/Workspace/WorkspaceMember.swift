//
//  WorkspaceMember.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/20/24.
//

import Foundation

struct WorkspaceMember: Decodable {
    let userId: String
    let email: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname
        case profileImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decode(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
    }
    
    init(
        userId: String,
        email: String,
        nickname: String,
        profileImage: String?
    ) {
        self.userId = userId
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
    
}

extension WorkspaceMember: Equatable {
    static func ==(lhs: WorkspaceMember, rhs: WorkspaceMember) -> Bool {
        return lhs.userId == rhs.userId
        && lhs.nickname == rhs.nickname
        && lhs.email == rhs.email
    }
}

extension WorkspaceMember {
    var convertToLocalWorkspaceMember: LocalWorkspaceMember {
        LocalWorkspaceMember(userId: self.userId, email: self.email, nickname: self.nickname, profileImage: self.profileImage)
    }
}
