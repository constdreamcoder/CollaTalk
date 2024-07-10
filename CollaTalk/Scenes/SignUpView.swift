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
                    rightButtonAction: { store.dispatch(.signUpAction(.emailDoubleCheck)) },
                    isValid: store.state.signUpState.isEmailValid
                )
                .keyboardType(.emailAddress)
                
                InputView(
                    title: "닉네임",
                    placeholder: "닉네임을 입력하세요",
                    textFieldGetter: { store.state.signUpState.nickname },
                    textFieldSetter: { store.dispatch(.signUpAction(.writeNickname(nickname: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: store.state.signUpState.isNicknameValid
                )
                
                InputView(
                    title: "연락처",
                    placeholder: "전화번호를 입력하세요",
                    textFieldGetter: { store.state.signUpState.phoneNumber },
                    textFieldSetter: { store.dispatch(.signUpAction(.writePhoneNumber(phoneNumber: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: store.state.signUpState.isPhoneNumberValid
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
                    rightButtonAction: {},
                    isValid: store.state.signUpState.isPWValid
                )
                
                InputView(
                    title: "비밀번호 확인",
                    placeholder: "비밀번호를 한 번 더 입력하세요",
                    isSecure: true,
                    textFieldGetter: { "" },
                    textFieldSetter: { _ in },
                    secureFieldGetter: { store.state.signUpState.passwordForMatchCheck },
                    secureFieldSetter: { store.dispatch(.signUpAction(.writePasswordForMatchCheck(passwordForMatchCheck: $0))) },
                    rightButtonAction: {},
                    isValid: store.state.signUpState.isPWForMatchCheckValid
                )
                
                Spacer()
                
                // TODO: - 키보드에 따라 버튼이 같이 올라가고 사라지는 기능 구현
                CustomButton {
                    print("가입하기")
                    store.dispatch(.signUpAction(.join))
                } label: {
                    Text("가입하기")
                }
                .disabled(!isSignUpButtonValid())
                .bottomButtonShape(isSignUpButtonValid() ? .brandGreen : .brandInactive)
            }
        }
    }
}

extension SignUpView {
    private func isSignUpButtonValid() -> Bool {
        !store.state.signUpState.isEmailEmpty
        && !store.state.signUpState.isNicknameEmpty
        && !store.state.signUpState.isPWEmpty
        && !store.state.signUpState.isPWForMatchCheckEmpty
    }
}

#Preview {
    SignUpView(isPresented: .constant(false))
}
