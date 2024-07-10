//
//  SignUpView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject private var store: AppStore
    
    @Binding var isPresented: Bool
    
    @State private var text = ""
    
    var body: some View {
        
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                NavigationBarForCreatingNewFeature(title: .signUp, isPresented: $isPresented)
                
                InputView(
                    title: "이메일",
                    placeholder: "이메일을 입력하세요",
                    showRightButton: true,
                    isRightButtonAble: !store.state.signUpState.isEmailEmpty,
                    textFieldGetter: { store.state.signUpState.email },
                    textFieldSetter: { store.dispatch(.signUpAction(.writeEmail(email: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: { store.dispatch(.signUpAction(.emailDoubleCheck)) }
                )
                .keyboardType(.emailAddress)
                
                InputView(
                    title: "닉네임",
                    placeholder: "닉네임을 입력하세요",
                    textFieldGetter: { store.state.signUpState.nickname },
                    textFieldSetter: { store.dispatch(.signUpAction(.writeNickname(nickname: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {}
                )
                
                InputView(
                    title: "연락처",
                    placeholder: "전화번호를 입력하세요",
                    textFieldGetter: { store.state.signUpState.phoneNumber },
                    textFieldSetter: { store.dispatch(.signUpAction(.writeNickname(nickname: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {}
                )
                .keyboardType(.numberPad)
                
                InputView(
                    title: "비밀번호",
                    placeholder: "비밀번호를 입력하세요",
                    isSecure: true,
                    textFieldGetter: { "" },
                    textFieldSetter: { _ in },
                    secureFieldGetter: { store.state.signUpState.password },
                    secureFieldSetter: { store.dispatch(.signUpAction(.writePassword(password: $0))) },
                    rightButtonAction: {}
                )
                
                InputView(
                    title: "비밀번호 확인",
                    placeholder: "비밀번호를 한 번 더 입력하세요",
                    isSecure: true,
                    textFieldGetter: { "" },
                    textFieldSetter: { _ in },
                    secureFieldGetter: { store.state.signUpState.passwordForMatchCheck },
                    secureFieldSetter: { store.dispatch(.signUpAction(.writePasswordForMatchCheck(passwordForMatchCheck: $0))) },
                    rightButtonAction: {}
                )
                
                Spacer()
                
                // TODO: - 키보드에 따라 버튼이 같이 올라가고 사라지는 기능 구현
                CustomButton {
                    print("가입하기")
                    store.dispatch(.signUpAction(.join))
                } label: {
                    Text("가입하기")
                }
                .bottomButtonShape(.brandGreen)
            }
        }
    }
}

#Preview {
    SignUpView(isPresented: .constant(false))
}
