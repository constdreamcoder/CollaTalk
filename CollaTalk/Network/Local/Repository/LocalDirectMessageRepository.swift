//
//  LocalDirectMessageRepository.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation
import RealmSwift

final class LocalDirectMessageRepository: BaseRepository<LocalDirectMessage> {
    
    static let shared = LocalDirectMessageRepository()
    
    private override init() { super.init() }
}

extension LocalDirectMessageRepository {
    
    /// DM 방 가장 최근 DM 조회
    func findLastestDM(_ roomId: String) -> LocalDirectMessage? {
        // TODO: - 날짜별 Sorting 확인
        let dms: [LocalDirectMessage] = super.read().sorted(by: \.createdAt, ascending: true).map { $0 }
//        print("dhdhdhdhdhdhhdhd", dms)
        return super.read().sorted(by: \.createdAt, ascending: true).last(where: { $0.roomId == roomId })
    }
    
    /// 새로운 DM 생성
    func write(newDirectMessage: DirectMessage, sender: LocalWorkspaceMemeber?) {
        /// 로컬 DB(Realm) 저장을 위한 새로운 DM 생성
        let localDirectMessage = LocalDirectMessage(
            dmId: newDirectMessage.dmId,
            roomId: newDirectMessage.roomId,
            content: newDirectMessage.content,
            createdAt: newDirectMessage.createdAt,
            files: newDirectMessage.files,
            user: sender
        )
        
        /// 로컬 DB(Realm)에 새로운 DM 저장
        super.write(localDirectMessage)
    }
}
