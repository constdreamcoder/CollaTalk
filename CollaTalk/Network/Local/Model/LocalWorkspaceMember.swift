//
//  LocalWorkspaceMember.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation
import RealmSwift

final class LocalWorkspaceMember: Object {
    @Persisted(primaryKey: true) var userId: String
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(
        userId: String,
        email: String,
        nickname: String,
        profileImage: String? = nil
    ) {
        self.init()
        
        self.userId = userId
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

extension LocalWorkspaceMember {
    var convertToWorkspaceMember: WorkspaceMember {
        WorkspaceMember(userId: self.userId, email: self.email, nickname: self.nickname, profileImage: self.profileImage)
    }
}
