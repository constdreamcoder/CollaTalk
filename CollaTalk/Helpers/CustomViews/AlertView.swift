//
//  AlertView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/19/24.
//

import SwiftUI

enum AlertType {
    // MARK: - Workspace 관련 Alert
    case leavetWorkspaceAsAMember
    case leaveWorkspaceAsAnOwner
    case removeWorkspace
    case failToChangeWorkspaceOwner
    case changeWorkspaceOwner(newOwner: String)
    case none
        
    var title: String {
        switch self {
        case .leavetWorkspaceAsAMember, .leaveWorkspaceAsAnOwner:
            return "워크스페이스 나가기"
        case .removeWorkspace:
            return "워크스페이스 삭제"
        case .failToChangeWorkspaceOwner:
            return "워크스페이스 관리자 변경 불가"
        case .changeWorkspaceOwner(let newOwner):
            return "\(newOwner) 님을 관리자로 지정하시겠습니까?"
        case .none:
            return ""
        }
    }
    
    var message: String {
        switch self {
        case .leavetWorkspaceAsAMember:
            return "정말 이 워크스페이스를 떠나시겠습니까?"
        case .leaveWorkspaceAsAnOwner:
            return "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다."
        case .removeWorkspace:
            return "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다."
        case .failToChangeWorkspaceOwner:
            return "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다.\n새로운 멤버를 워크스페이스에 초대해보세요."
        case .changeWorkspaceOwner:
            return """
                    워크스페이스 관리자는 다음과 같은 권한이 있습니다.
                    · 워크스페이스 이름 또는 설명 변경
                    · 워크스페이스 삭제
                    · 워크스페이스 멤버 초대
                    """
        case .none:
            return ""
        }
    }
    
    var confirmButtonTitle: String {
        switch self {
        case .leavetWorkspaceAsAMember:
            return "나가기"
        case .leaveWorkspaceAsAnOwner, .failToChangeWorkspaceOwner, .changeWorkspaceOwner:
            return "확인"
        case .removeWorkspace:
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
        default: return !(lhs == rhs)
        }
    }
}

struct AlertView: View {
    
    let alertType: AlertType
    let confirmAction: () -> Void
    let cancelAction: (() -> Void)?
    
    init(
        alertType: AlertType,
        confirmAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        self.alertType = alertType
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.4).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Alert(
                    title: alertType.title,
                    message: alertType.message,
                    confirmButtonTitle: alertType.confirmButtonTitle,
                    confirmAction: confirmAction,
                    cancelAction: cancelAction
                )
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    AlertView(
        alertType: .leavetWorkspaceAsAMember,
        confirmAction: { print("나가기") },
        cancelAction: { print("취소") }
    )
}


struct AlertButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(8)
        }
    }
}

struct Alert: View {
    
    let title: String
    let message: String
    let confirmButtonTitle: String
    let confirmAction: () -> Void
    let cancelAction: (() -> Void)?
    
    init(title: String, message: String, confirmButtonTitle: String, confirmAction: @escaping () -> Void, cancelAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.confirmButtonTitle = confirmButtonTitle
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.title2)
                .foregroundStyle(.textPrimary)
            
            Text(message)
                .font(.body)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
            
            HStack {
                if let cancelAction {
                    AlertButton(
                        title: "취소",
                        backgroundColor: .brandInactive,
                        action: cancelAction
                    )
                }
                
                AlertButton(
                    title: confirmButtonTitle,
                    backgroundColor: .brandGreen,
                    action: confirmAction
                )
            }
        }
        .padding()
        .background(.brandWhite)
        .cornerRadius(16, corners: .allCorners)
        .shadow(radius: 10)
    }
}
