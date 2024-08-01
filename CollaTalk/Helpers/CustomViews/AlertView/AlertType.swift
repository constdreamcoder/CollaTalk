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
    case unableToChangeChannelOwner
    case changeWorkspaceOwner(newOwner: String)
    case changeChannelOwner(newOwner: String)
    case joinChannel(channelName: String)
    case leaveChannelAsAMember
    case leaveChannelAsAnOwner
    case deleteChannel
    case none
        
    var title: String {
        switch self {
        case .leavetWorkspaceAsAMember, .leaveWorkspaceAsAnOwner:
            return "워크스페이스 나가기"
        case .deleteWorkspace:
            return "워크스페이스 삭제"
        case .unableToChangeWorkspaceOwner:
            return "워크스페이스 관리자 변경 불가"
        case .unableToChangeChannelOwner:
            return "채널 관리자 변경 불가"
        case .changeWorkspaceOwner(let newOwner):
            return "\(newOwner) 님을 관리자로 지정하시겠습니까?"
        case .changeChannelOwner(let newOwner):
            return "\(newOwner) 님을 관리자로 지정하시겠습니까?"
        case .none:
            return ""
        case .joinChannel:
            return "채널 참여"
        case .leaveChannelAsAMember, .leaveChannelAsAnOwner:
            return "채널에서 나가기"
        case .deleteChannel:
            return "채널 삭제"
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
        case .unableToChangeChannelOwner:
            return "채널 멤버가 없어 관리자 변경을 할 수 없습니다."
        case .changeWorkspaceOwner:
            return """
                   워크스페이스 관리자는 다음과 같은 권한이 있습니다.
                   
                   · 워크스페이스 이름 또는 설명 변경
                   · 워크스페이스 삭제
                   · 워크스페이스 멤버 초대
                   """
        case .changeChannelOwner:
            return """
                   채널 관리자는 다음과 같은 권한이 있습니다.
                   
                   · 채널 이름 또는 설명 변경
                   · 채널 삭제
                   """
        case .joinChannel(let channelName):
            return "[\(channelName)] 채널에 참여하시겠습니까?"
        case .none:
            return ""
        case .leaveChannelAsAMember:
            return "나가기를 하면 채널 목록에서 삭제됩니다."
        case .leaveChannelAsAnOwner:
            return "회원님은 채널 관리자입니다. 채널 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다."
        case .deleteChannel:
            return "정말 이 채널을 삭제하시겠습니까? 삭제 시 멤버/채팅 등 채널 내의 모든 정보가 삭제되며 복구할 수 없습니다."
        }
    }
    
    var confirmButtonTitle: String {
        switch self {
        case .leavetWorkspaceAsAMember, .leaveChannelAsAMember:
            return "나가기"
        case .leaveWorkspaceAsAnOwner, .unableToChangeWorkspaceOwner, .changeWorkspaceOwner, .joinChannel, .unableToChangeChannelOwner, .changeChannelOwner, .leaveChannelAsAnOwner:
            return "확인"
        case .deleteWorkspace, .deleteChannel:
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
        case (.changeChannelOwner(let lhsNewOwner) , .changeChannelOwner(let rhsNewOwner)):
            return !(lhsNewOwner == rhsNewOwner)
        default: return !(lhs == rhs)
        }
    }
}
