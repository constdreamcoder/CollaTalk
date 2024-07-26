//
//  LocalWorkspaceMemeberRepository.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation
import RealmSwift

final class LocalWorkspaceMemeberRepository: BaseRepository<LocalWorkspaceMemeber> {
    
    static let shared = LocalWorkspaceMemeberRepository()
    
    private override init() { super.init() }
}

extension LocalWorkspaceMemeberRepository {
    
    /// DM 작성자 존재 여부 판별
    func isSenderExist(_ dm: DirectMessage) -> Bool {
        super.read().contains(where: { $0.userId == dm.user.userId })
    }
    
    /// DM 작성자 검색
    func findSender(_ dm: DirectMessage) -> LocalWorkspaceMemeber? {
        super.read().first(where: { $0.userId == dm.user.userId })
    }
    
    /// 기존 DM 작성자가 있는지 여부 확인
    func createSender(_ newDM: DirectMessage) -> LocalWorkspaceMemeber? {
        var localWorkspaceMemeber: LocalWorkspaceMemeber?
        if isSenderExist(newDM) {
            localWorkspaceMemeber = LocalWorkspaceMemeberRepository.shared.findSender(newDM)
        } else {
            localWorkspaceMemeber = LocalWorkspaceMemeber(
                userId: newDM.user.userId,
                email: newDM.user.email,
                nickname: newDM.user.nickname,
                profileImage: newDM.user.profileImage
            )
        }
        
        return localWorkspaceMemeber
    }
}
