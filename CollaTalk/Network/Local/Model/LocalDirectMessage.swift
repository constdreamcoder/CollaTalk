//
//  LocalDirectMessage.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation
import RealmSwift

final class LocalDirectMessage: Object {
    @Persisted(primaryKey: true) var dmId: String
    @Persisted var roomId: String
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    @Persisted var user: LocalWorkspaceMemeber?
    
    convenience init(
        dmId: String,
        roomId: String,
        content: String? = nil,
        createdAt: String,
        files: [String],
        user: LocalWorkspaceMemeber? = nil
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
