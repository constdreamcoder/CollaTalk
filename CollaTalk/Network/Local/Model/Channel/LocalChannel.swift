//
//  LocalChannel.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/30/24.
//

import Foundation
import RealmSwift

final class LocalChannel: Object {
    @Persisted(primaryKey: true) var channelId: String
    @Persisted var name: String
    @Persisted var desc: String?
    @Persisted var coverImage: String?
    @Persisted var ownerId: String
    @Persisted var createdAt: String
    @Persisted var channelMembers: List<LocalWorkspaceMember>
    @Persisted var lastChat: LastLocalChannelChat?
    @Persisted var channelChats: List<LocalChannelChat>
    @Persisted var unreadChannelChatCount: Int
    
    convenience init(
        channelId: String, 
        name: String,
        desc: String? = nil,
        coverImage: String? = nil,
        ownerId: String,
        createdAt: String,
        channelMembers: [LocalWorkspaceMember] = [],
        lastChat: LastLocalChannelChat? = nil,
        channelChats: [LocalChannelChat] = [],
        unreadChannelChatCount: Int = 0
    ) {
        self.init()
        
        self.channelId = channelId
        self.name = name
        self.desc = desc
        self.coverImage = coverImage
        self.ownerId = ownerId
        self.createdAt = createdAt
        self.channelMembers.append(objectsIn: channelMembers)
        self.lastChat = lastChat
        self.channelChats.append(objectsIn: channelChats)
        self.unreadChannelChatCount = unreadChannelChatCount
    }
}

extension LocalChannel {
    var convertToChannel: Channel {
        let channelMembers: [WorkspaceMember] = self.channelMembers.map { $0.convertToWorkspaceMember }
        return Channel(
            channelId: self.channelId,
            name: self.name,
            description: self.desc,
            coverImage: self.coverImage,
            ownerId: self.ownerId,
            createdAt: self.createdAt,
            channelMembers: channelMembers
        )
    }
}

final class LastLocalChannelChat: EmbeddedObject {
    @Persisted var chatId: String
    @Persisted var channelId: String
    @Persisted var channelName: String
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    @Persisted var sender: LocalWorkspaceMember?
    
    convenience init(
        chatId: String,
        channelId: String,
        channelName: String,
        content: String? = nil,
        createdAt: String,
        files: [String],
        sender: LocalWorkspaceMember? = nil
    ) {
        self.init()
        
        self.chatId = chatId
        self.channelId = channelId
        self.channelName = channelName
        self.content = content
        self.createdAt = createdAt
        self.files.append(objectsIn: files)
        self.sender = sender
    }
}
