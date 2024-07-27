//
//  LocalWorkspaceMemberRepository.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation
import RealmSwift

final class LocalWorkspaceMemberRepository: BaseRepository<LocalWorkspaceMemeber> {
    
    static let shared = LocalWorkspaceMemberRepository()
    
    private override init() { super.init() }
}

extension LocalWorkspaceMemberRepository {
    
    /// 워크스페이스 멤버 존재 여부 확인
    func isExist(_ userId: String) -> Bool {
        super.read().contains(where: { $0.userId == userId })
    }
    
    /// DM 작성자 검색
    func findOne(_ userId: String) -> LocalWorkspaceMemeber? {
        super.read().first(where: { $0.userId == userId })
    }
    
    /// 기존 DM 작성자가 있는지 여부 확인
    func createSender(_ newDM: DirectMessage) -> LocalWorkspaceMemeber? {
        let userId = newDM.user.userId
        
        var localWorkspaceMemeber: LocalWorkspaceMemeber?
        if isExist(userId) {
            localWorkspaceMemeber = LocalWorkspaceMemberRepository.shared.findOne(userId)
        } else {
            localWorkspaceMemeber = LocalWorkspaceMemeber(
                userId: userId,
                email: newDM.user.email,
                nickname: newDM.user.nickname,
                profileImage: newDM.user.profileImage
            )
        }
        
        return localWorkspaceMemeber
    }
    
    func write(_ workspaceMember: WorkspaceMember) {
        let localWorkspaceMemeber = LocalWorkspaceMemeber(
            userId: workspaceMember.userId,
            email: workspaceMember.email,
            nickname: workspaceMember.nickname,
            profileImage: workspaceMember.profileImage
        )
        
        LocalWorkspaceMemberRepository.shared.write(localWorkspaceMemeber)
    }
}
