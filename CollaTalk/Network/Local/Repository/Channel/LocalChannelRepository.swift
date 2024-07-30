//
//  LocalChannelRepository.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/30/24.
//

import Foundation
import RealmSwift

final class LocalChannelRepository: BaseRepository<LocalChannel> {
    
    static let shared = LocalChannelRepository()
    
    private override init() { super.init() }
}

extension LocalChannelRepository {
    
    var localChannelsSortedByDescending: [LocalChannel] {
        super.read().sorted(by: \.lastChat?.createdAt, ascending: false).map { $0 }
    }
    
    /// 기존 채널 존재 여부 판별
    func isExist(_ channelId: String) -> Bool {
        super.read().contains(where: { $0.channelId ==  channelId})
    }
    
    /// 채널  하나 조회
    func findOne(_ channelId: String) -> LocalChannel? {
        super.read().first(where: { $0.channelId == channelId})
    }

    /// 채널 목록 생성 및 업데이트
    func updateChannelList(_ channels: [LocalChannel]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(channels, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    /// 새로운 채널 채팅 목록 업데이트
    func updateChannelChats(_ chatList: [LocalChannelChat], channelId: String) {
        guard let channel = findOne(channelId) else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                channel.channelChats.append(objectsIn: chatList)
            }
        } catch {
            print(error)
        }
    }
    
    /// 채널 마지막 채팅 업데이트
    func updateLastChannelChat(_ lastChannelChatFromRemote: ChannelChat, lastSender: LocalWorkspaceMember?) {
        let lastestChannelChat = LastLocalChannelChat(
            chatId: lastChannelChatFromRemote.chatId,
            channelId: lastChannelChatFromRemote.channelId,
            channelName: lastChannelChatFromRemote.channelName,
            content: lastChannelChatFromRemote.content,
            createdAt: lastChannelChatFromRemote.createdAt,
            files: lastChannelChatFromRemote.files,
            sender: lastSender
        )
        
        guard let existingChannel = findOne(lastChannelChatFromRemote.channelId) else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                existingChannel.lastChat = lastestChannelChat
            }
        } catch {
            print(error)
        }
    }
    
    /// 읽지 않은 채널 채팅 개수
    func updateUnreadChannelChatCount(_ unreadChannelChatCount: UnreadChannelChatCount) {
        guard let existingChannel = findOne(unreadChannelChatCount.channelId) else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                existingChannel.unreadChannelChatCount = unreadChannelChatCount.count
            }
        } catch {
            print(error)
        }
    }
}

