//
//  LocalChannelChat.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/30/24.
//

import Foundation
import RealmSwift

final class LocalChannelChat: Object {
    @Persisted(primaryKey: true) var chatId: String
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
        files: [String] = [],
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
