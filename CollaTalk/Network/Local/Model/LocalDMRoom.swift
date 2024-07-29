//
//  LocalDMRoom.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation
import RealmSwift

final class LocalDMRoom: Object {
    @Persisted(primaryKey: true) var roomId: String
    @Persisted var createdAt: String
    @Persisted var opponent: LocalWorkspaceMember?
    
    @Persisted var dms: List<LocalDirectMessage>
    @Persisted var lastDM: LastLocalDirectMessage?
    @Persisted var unreadDMCount: Int

    convenience init(
        roomId: String,
        createdAt: String,
        opponent: LocalWorkspaceMember? = nil,
        lastDM: LastLocalDirectMessage? = nil,
        unreadDMCount: Int = 0
    ) {
        self.init()
        
        self.roomId = roomId
        self.createdAt = createdAt
        self.opponent = opponent
        self.lastDM = lastDM
        self.unreadDMCount = unreadDMCount        
    }
}

final class LastLocalDirectMessage: EmbeddedObject {
    @Persisted var dmId: String
    @Persisted var roomId: String
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    @Persisted var user: LocalWorkspaceMember?
    
    convenience init(
        dmId: String,
        roomId: String,
        content: String? = nil,
        createdAt: String,
        files: [String],
        user: LocalWorkspaceMember? = nil
    ) {
        self.init()
        
        self.dmId = dmId
        self.roomId = roomId
        self.content = content
        self.createdAt = createdAt
        
        files.forEach { [weak self] file in
            guard let self else { return }
            self.files.append(file)
        }
        
        self.user = user
    }
}

