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
    
    /// 채널 가장 최근 채팅 조회
    func findLastestChannelChat(_ channelId: String) -> LocalChannelChat? {
        super.read().sorted(by: \.createdAt, ascending: true).last(where: { $0.channelId == channelId })
    }
    
    /// 새로운 채널 채팅 생성
    func write(newChannelChat: ChannelChat, sender: LocalWorkspaceMember?) {
        /// 로컬 DB(Realm) 저장을 위한 새로운 채널 채팅 생성
        let localChannelChat = LocalChannelChat(
            chatId: newChannelChat.chatId,
            channelId: newChannelChat.channelId,
            channelName: newChannelChat.channelName,
            content: newChannelChat.content,
            createdAt: newChannelChat.createdAt,
            files: newChannelChat.files,
            sender: sender
        )
        
        /// 로컬 DB(Realm)에 새로운 채널 채팅 저장
        super.write(localChannelChat)
    }
}
