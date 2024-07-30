//
//  LocalWorkspaceMemberRepository.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation
import RealmSwift

final class LocalWorkspaceMemberRepository: BaseRepository<LocalWorkspaceMember> {
    
    static let shared = LocalWorkspaceMemberRepository()
    
    private override init() { super.init() }
}

extension LocalWorkspaceMemberRepository {
    
    /// 워크스페이스 멤버 존재 여부 확인
    func isExist(_ userId: String) -> Bool {
        super.read().contains(where: { $0.userId == userId })
    }
    
    /// DM 작성자 검색
    func findOne(_ userId: String) -> LocalWorkspaceMember? {
        super.read().first(where: { $0.userId == userId })
    }
    
    /// 기존 DM 작성자가 있는지 여부 확인
    func createSender(_ newDM: DirectMessage) -> LocalWorkspaceMember? {
        let userId = newDM.user.userId
        
        var localWorkspaceMember: LocalWorkspaceMember?
        if isExist(userId) {
            localWorkspaceMember = LocalWorkspaceMemberRepository.shared.findOne(userId)
        } else {
            localWorkspaceMember = LocalWorkspaceMember(
                userId: userId,
                email: newDM.user.email,
                nickname: newDM.user.nickname,
                profileImage: newDM.user.profileImage
            )
        }
        
        return localWorkspaceMember
    }
    
    func createSender(_ newChannelChat: ChannelChat) -> LocalWorkspaceMember? {
        guard let user = newChannelChat.user else { return nil}
        
        var localWorkspaceMember: LocalWorkspaceMember?
        if isExist(user.userId) {
            localWorkspaceMember = LocalWorkspaceMemberRepository.shared.findOne(user.userId)
        } else {
            localWorkspaceMember = LocalWorkspaceMember(
                userId: user.userId,
                email: user.email,
                nickname: user.nickname,
                profileImage: user.profileImage
            )
        }
        
        return localWorkspaceMember
    }
    
    func write(_ workspaceMember: WorkspaceMember) {
        let localWorkspaceMember = LocalWorkspaceMember(
            userId: workspaceMember.userId,
            email: workspaceMember.email,
            nickname: workspaceMember.nickname,
            profileImage: workspaceMember.profileImage
        )
        
        LocalWorkspaceMemberRepository.shared.write(localWorkspaceMember)
    }
}
