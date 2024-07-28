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
    
    /// DM 방 목록 생성 및 업데이트
    func updateDMRoomList(_ dmRooms: [LocalDMRoom]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dmRooms, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    /// DM 방 마지막 DM 업데이트
    func updateLastDM(_ lastDMFromRemote: DirectMessage, lastSender: LocalWorkspaceMemeber?) {
        let lastestDM = LastLocalDirectMessage(
            dmId: lastDMFromRemote.dmId,
            roomId: lastDMFromRemote.roomId,
            content: lastDMFromRemote.content,
            createdAt: lastDMFromRemote.createdAt,
            files: lastDMFromRemote.files,
            user: lastSender
        )
        
        guard let existingDMRoom = findOne(lastDMFromRemote.roomId) else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                existingDMRoom.lastDM = lastestDM
            }
        } catch {
            print(error)
        }
    }
    
    /// DM 방 마지막 DM 업데이트
    func updateLastDM(_ lastDMFromLocal: LastLocalDirectMessage) {
        guard let existingDMRoom = findOne(lastDMFromLocal.roomId) else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                existingDMRoom.lastDM = lastDMFromLocal
            }
        } catch {
            print(error)
        }
    }
    
    /// 읽지 않은 DM 개수
    func updateUnreadDMCount(_ unreadDMCount: UnreadDMCount) {
        guard let existingDMRoom = findOne(unreadDMCount.roomId) else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                existingDMRoom.unreadDMCount = unreadDMCount.count
            }
        } catch {
            print(error)
        }
    }
    
    /// 새로운 DM 목록 업데이트
    func updateDMs(_ dmList: [LocalDirectMessage], roomId: String) {
        guard let dmRoom = findOne(roomId) else { return }
                
        
        do {
            let realm = try Realm()
            try realm.write {
                dmRoom.dms.append(objectsIn: dmList)
            }
        } catch {
            print(error)
        }
    }
}

