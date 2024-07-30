//
//  LocalChannelChatRepository.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/30/24.
//

import Foundation
import RealmSwift

final class LocalChannelChatRepository: BaseRepository<LocalChannelChat> {
    
    static let shared = LocalChannelChatRepository()
    
    private override init() { super.init() }
}

extension LocalChannelChatRepository {
    
}
