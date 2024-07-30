//
//  ChannelRoom.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/29/24.
//

import Foundation

struct ChannelChat: Decodable {
    let channelId: String
    let channelName: String
    let chatId: String
    let content: String?
    let createdAt: String
    let files: [String]
    let user: WorkspaceMember?
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case channelName
        case chatId = "chat_id"
        case content
        case createdAt
        case files
        case user
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channelId = try container.decode(String.self, forKey: .channelId)
        self.channelName = try container.decode(String.self, forKey: .channelName)
        self.chatId = try container.decode(String.self, forKey: .chatId)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.files = try container.decode([String].self, forKey: .files)
        self.user = try container.decode(WorkspaceMember.self, forKey: .user)
    }
    
    init(
        channelId: String,
        channelName: String,
        chatId: String, 
        content: String?,
        createdAt: String, 
        files: [String],
        user: WorkspaceMember? = nil
    ) {
        self.channelId = channelId
        self.channelName = channelName
        self.chatId = chatId
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}

extension ChannelChat {
    var convertToLocalChannelChat: LocalChannelChat {
        LocalChannelChat(
            chatId: self.chatId,
            channelId: self.channelId,
            channelName: self.channelName,
            content: self.content,
            createdAt: self.createdAt,
            files: self.files,
            sender: self.user?.convertToLocalWorkspaceMember
        )
    }
}
