//
//  EditNicknameView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/3/24.
//

import SwiftUI

struct EditNicknameView: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                
                NavigationFrameView(
                    title: "닉네임",
                    leftButtonAction: {
                        navigationRouter.pop()
                    }
                )
                
                InputView(
                    title: "",
                    placeholder: "닉네임을 입력하세요",
                    textFieldGetter: { store.state.editNicknameState.nickname },
                    textFieldSetter: { store.dispatch(.editNicknameAction(.writeNickname(nickname: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: store.state.signUpState.isNicknameValid
                )
                
                Spacer()
                
                CustomButton {
                    print("완료")
                    store.dispatch(.editNicknameAction(.changeNickname))
                } label: {
                    Text("완료")
                }
                .disabled( store.state.editNicknameState.isNicknameEmpty)
                .bottomButtonShape(!store.state.editNicknameState.isNicknameEmpty ? .brandGreen : .brandInactive)
                .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    EditNicknameView()
}
