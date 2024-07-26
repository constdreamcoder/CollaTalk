//
//  LocalDMRoomRepository.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation
import RealmSwift

final class LocalDMRoomRepository: BaseRepository<LocalDMRoom> {
    
    static let shared = LocalDMRoomRepository()
    
    private override init() { super.init() }
}

extension LocalDMRoomRepository {
    
    var localDMRoomsSortedByDescending: [LocalDMRoom] {
        super.read().sorted(by: \.lastDM?.createdAt, ascending: false).map { $0 }
    }
    
    /// 기존 DM 방 존재 여부 판별
    func isExist(_ roomId: String) -> Bool {
        super.read().contains(where: { $0.roomId ==  roomId})
    }
    
    /// DM 방  하나 조회
    func findOne(_ rommId: String) -> LocalDMRoom? {
        super.read().first(where: { $0.roomId == rommId})
    }
    
    /// 새로운 DM 생성
    func write(_ chatRoom: DMRoom) {
        let localWorkspaceMemeber = LocalWorkspaceMemeber(
            userId: chatRoom.user.userId,
            email: chatRoom.user.email,
            nickname: chatRoom.user.nickname,
            profileImage: chatRoom.user.profileImage
        )
        
        let localDMRoom = LocalDMRoom(
            roomId: chatRoom.roomId,
            createdAt: chatRoom.createdAt,
            opponent: localWorkspaceMemeber
        )
        
        super.write(localDMRoom)
    }
    
    func updateLastDM(_ lastDMFromRemote: DirectMessage, lastSender: LocalWorkspaceMemeber?) {
        let lastestDM = LocalDirectMessage(
            dmId: lastDMFromRemote.dmId,
            roomId: lastDMFromRemote.roomId,
            content: lastDMFromRemote.content,
            createdAt: lastDMFromRemote.createdAt,
            files: lastDMFromRemote.files,
            user: lastSender
        )
        
        guard let existingDMRoom = findOne(lastDMFromRemote.roomId) else { return }
        
        let updatedLocalDMRoom = LocalDMRoom(
            roomId: existingDMRoom.roomId,
            createdAt: existingDMRoom.createdAt,
            opponent: existingDMRoom.opponent,
            lastDM: lastestDM
        )
        
        super.update(updatedLocalDMRoom)
    }
    
    func updateUnreadDMCount(_ unreadDMCount: UnreadDMCount) {
        guard let existingDMRoom = findOne(unreadDMCount.roomId) else { return }

        let updatedLocalDMRoom = LocalDMRoom(
            roomId: existingDMRoom.roomId,
            createdAt: existingDMRoom.createdAt,
            opponent: existingDMRoom.opponent,
            lastDM: existingDMRoom.lastDM,
            unreadDMCount: unreadDMCount.count
        )
        
        LocalDMRoomRepository.shared.update(updatedLocalDMRoom)
    }
}

