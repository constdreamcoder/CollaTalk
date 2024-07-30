//
//  AlertType.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/20/24.
//

import Foundation

enum AlertType {
    // MARK: - Workspace 관련 Alert
    case leavetWorkspaceAsAMember
    case leaveWorkspaceAsAnOwner
    case deleteWorkspace
    case unableToChangeWorkspaceOwner
    case changeWorkspaceOwner(newOwner: String)
    case joinChannel(channelName: String)
    case none
        
    var title: String {
        switch self {
        case .leavetWorkspaceAsAMember, .leaveWorkspaceAsAnOwner:
            return "워크스페이스 나가기"
        case .deleteWorkspace:
            return "워크스페이스 삭제"
        case .unableToChangeWorkspaceOwner:
            return "워크스페이스 관리자 변경 불가"
        case .changeWorkspaceOwner(let newOwner):
            return "\(newOwner) 님을 관리자로 지정하시겠습니까?"
        case .none:
            return ""
        case .joinChannel:
            return "채널 참여"
        }
    }
    
    var message: String {
        switch self {
        case .leavetWorkspaceAsAMember:
            return "정말 이 워크스페이스를 떠나시겠습니까?"
        case .leaveWorkspaceAsAnOwner:
            return "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다."
        case .deleteWorkspace:
            return "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다."
        case .unableToChangeWorkspaceOwner:
            return "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다.\n새로운 멤버를 워크스페이스에 초대해보세요."
        case .changeWorkspaceOwner:
            return """
                    워크스페이스 관리자는 다음과 같은 권한이 있습니다.
                    · 워크스페이스 이름 또는 설명 변경
                    · 워크스페이스 삭제
                    · 워크스페이스 멤버 초대
                    """
        case .joinChannel(let channelName):
            return "[\(channelName)] 채널에 참여하시겠습니까?"
        case .none:
            return ""
        }
    }
    
    var confirmButtonTitle: String {
        switch self {
        case .leavetWorkspaceAsAMember:
            return "나가기"
        case .leaveWorkspaceAsAnOwner, .unableToChangeWorkspaceOwner, .changeWorkspaceOwner, .joinChannel:
            return "확인"
        case .deleteWorkspace:
            return "삭제"
        case .none:
            return ""
        }
    }
}

extension AlertType: Equatable {
    static func != (lhs: AlertType, rhs: AlertType) -> Bool {
        switch (lhs, rhs) {
        case (.changeWorkspaceOwner(let lhsNewOwner), .changeWorkspaceOwner(let rhsNewOwner)):
            return !(lhsNewOwner == rhsNewOwner)
        case (.joinChannel(let lhsChannelName), .joinChannel(let rhsChannelName)):
            return !(lhsChannelName == rhsChannelName)
        default: return !(lhs == rhs)
        }
    }
}
