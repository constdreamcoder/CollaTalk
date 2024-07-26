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
    
    /// 기존 채팅방 존재 여부 판별
    func isExist(_ dmRoom: DMRoom) -> Bool {
        super.read().contains(where: { $0.roomId ==  dmRoom.roomId})
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
}

