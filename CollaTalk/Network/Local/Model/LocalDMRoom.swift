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
    @Persisted var opponent: LocalWorkspaceMemeber?
    @Persisted var lastDM: LocalDirectMessage?
    @Persisted var unreadDMCount: Int
    
    convenience init(
        roomId: String,
        createdAt: String,
        opponent: LocalWorkspaceMemeber? = nil,
        lastDM: LocalDirectMessage? = nil,
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
