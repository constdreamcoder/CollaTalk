//
//  InviteMemberView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/22/24.
//

import SwiftUI

struct InviteMemberView: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                SheetNavigation(
                    title: .inviteMember,
                    isPresented: Binding(
                        get: { store.state.navigationState.isInviteMemeberViewPresented },
                        set: { store.dispatch(.navigationAction(.presentInviteMemeberView(present: $0)))
                        }
                    ),
                    transitionAction: {}
                )
                
                InputView(
                    title: "이메일",
                    placeholder: "초대하려는 팀원의 이메일을 입력하세요.",
                    textFieldGetter: { store.state.inviteMemberState.email },
                    textFieldSetter: { store.dispatch(.inviteMemeberAction(.writeEmail(email: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: true
                )
                
                Spacer()
                
                CustomButton {
                    print("초대 보내기")
                    store.dispatch(.inviteMemeberAction(.inviteMember))
                } label: {
                    Text("초대 보내기")
                }
                .disabled(!inviteMemberButtonValid)
                .bottomButtonShape(inviteMemberButtonValid ? .brandGreen : .brandInactive)
            }
        }
    }
}

extension InviteMemberView {
    private var inviteMemberButtonValid: Bool {
        !store.state.inviteMemberState.isEmailEmpty
    }
}

#Preview {
    InviteMemberView()
}
