//
//  DMRoom.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/25/24.
//

import Foundation

struct DMRoom: Decodable {
    let roomId: String
    let createdAt: String
    let user: WorkspaceMember
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case createdAt
        case user
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.roomId = try container.decode(String.self, forKey: .roomId)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.user = try container.decode(WorkspaceMember.self, forKey: .user)
    }
}
