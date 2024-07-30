//
//  Channel.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/15/24.
//

import Foundation

struct Channel: Decodable {
    let channelId: String
    let name: String
    let description: String?
    let coverImage: String?
    let ownerId: String
    let createdAt: String
    let channelMembers: [WorkspaceMember]?
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case name
        case description
        case coverImage
        case ownerId = "owner_id"
        case createdAt
        case channelMembers
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channelId = try container.decode(String.self, forKey: .channelId)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.coverImage = try container.decodeIfPresent(String.self, forKey: .coverImage)
        self.ownerId = try container.decode(String.self, forKey: .ownerId)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.channelMembers = try container.decodeIfPresent([WorkspaceMember].self, forKey: .channelMembers)
    }
}

extension Channel {
    var convertToLocalChannel: LocalChannel {
        let channelMembers = self.channelMembers ?? []
        
        return LocalChannel(
            channelId: self.channelId,
            name: self.name,
            desc: self.description,
            coverImage: self.coverImage,
            ownerId: self.ownerId,
            createdAt: self.createdAt,
            channelMembers: channelMembers.map { $0.convertToLocalWorkspaceMember }
        )
    }
}
