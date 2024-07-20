//
//  AlertView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/19/24.
//

import SwiftUI

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
                    alertType: alertType, 
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
    
    let alertType: AlertType
    let title: String
    let message: String
    let confirmButtonTitle: String
    let confirmAction: () -> Void
    let cancelAction: (() -> Void)?
    
    init(
        alertType: AlertType,
        title: String,
        message: String,
        confirmButtonTitle: String, 
        confirmAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        self.alertType = alertType
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
            
            switch alertType {
            case .changeWorkspaceOwner:
                Text(message)
                    .font(.body)
                    .foregroundStyle(.textSecondary)
                    .multilineTextAlignment(.leading)
            default:
                Text(message)
                    .font(.body)
                    .foregroundStyle(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
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
