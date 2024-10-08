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
    
    /// 채널 목록 생성 및 업데이트
    func updateChannelList(_ updatedChannels: [Channel]) {
        do {
            let realm = try Realm()
            try realm.write {
                let convertedUpdatedChannels: [LocalChannel] = updatedChannels.map {
                    if let existingChannel = LocalChannelRepository.shared.findOne($0.channelId) {
                        existingChannel.name = $0.convertToLocalChannel.name
                        existingChannel.desc = $0.convertToLocalChannel.desc
                        existingChannel.coverImage = $0.convertToLocalChannel.coverImage
                        existingChannel.ownerId = $0.convertToLocalChannel.ownerId
                        existingChannel.createdAt = $0.convertToLocalChannel.createdAt
                        return existingChannel
                    }
                    return $0.convertToLocalChannel
                }
                
                realm.add(convertedUpdatedChannels, update: .modified)
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
    
    /// 채널 이름, 설명 업데이트
    func updateChannelNameAndDescription(with updatdChanel: Channel) {
        guard let exisitingChannel = findOne(updatdChanel.channelId) else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                exisitingChannel.name = updatdChanel.name
                exisitingChannel.desc = updatdChanel.description
            }
        } catch {
            print(error)
        }
    }
    
    /// 채널 멤버 업데이트
    func updateChannelMembers(channelId: String, newChannelMembers: [LocalWorkspaceMember]) {
        guard let existingChannel = findOne(channelId) else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                existingChannel.channelMembers.removeAll()
                let convertedChannelMembers = List<LocalWorkspaceMember>()
                convertedChannelMembers.append(objectsIn: newChannelMembers)
                existingChannel.channelMembers = convertedChannelMembers
            }
        } catch {
            print(error)
        }
    }
    
    /// 채널 관리자 업데이트
    func updateChannelOwner(_ channelId: String, newOwnerId: String) {
        guard let existingChannel = findOne(channelId) else { return }

        do {
            let realm = try Realm()
            try realm.write {
                existingChannel.ownerId = newOwnerId
            }
        } catch {
            print(error)
        }
    }
}

