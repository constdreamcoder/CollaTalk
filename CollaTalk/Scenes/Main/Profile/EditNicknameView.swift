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
                
                Spacer()
                    .frame(height: 12)
                
                InputView(
                    title: "닉네임",
                    placeholder: "닉네임을 입력하세요",
                    textFieldGetter: { store.state.myProfileState.nickname },
                    textFieldSetter: { store.dispatch(.editProfileAction(.writeNickname(nickname: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: store.state.signUpState.isNicknameValid
                )
                
                Spacer()
                
                CustomButton {
                    print("완료")
                } label: {
                    Text("완료")
                }
                .disabled( store.state.myProfileState.isNicknameEmpty)
                .bottomButtonShape(!store.state.myProfileState.isNicknameEmpty ? .brandGreen : .brandInactive)
                .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    EditNicknameView()
}
