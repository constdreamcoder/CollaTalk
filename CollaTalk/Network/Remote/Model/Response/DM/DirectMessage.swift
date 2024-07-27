//
//  DirectMessage.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/25/24.
//

import Foundation

struct DirectMessage: Decodable {
    let dmId: String
    let roomId: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: WorkspaceMember
    
    enum CodingKeys: String, CodingKey {
        case dmId = "dm_id"
        case roomId = "room_id"
        case content
        case createdAt
        case files
        case user
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dmId = try container.decode(String.self, forKey: .dmId)
        self.roomId = try container.decode(String.self, forKey: .roomId)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.files = try container.decode([String].self, forKey: .files)
        self.user = try container.decode(WorkspaceMember.self, forKey: .user)
    }
    
    init(
        dmId: String,
        roomId: String,
        content: String?,
        createdAt: String,
        files: [String],
        user: WorkspaceMember
    ) {
        self.dmId = dmId
        self.roomId = roomId
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}

extension DirectMessage {
    var convertToLocalDirectMessage: LocalDirectMessage {
        LocalDirectMessage(
            dmId: self.dmId,
            roomId: self.roomId,
            content: self.content,
            createdAt: self.createdAt,
            files: self.files,
            user: self.user.convertToLocalWorkspaceMember
        )
    }
}
