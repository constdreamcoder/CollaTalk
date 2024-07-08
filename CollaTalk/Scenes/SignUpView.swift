//
//  SignUpView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct SignUpView: View {
    
    @Binding var isPresented: Bool
    
    @State private var text = ""

    var body: some View {
        
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                NavigationBarForCreatingNewFeature(title: .signUp, isPresented: $isPresented)
                
//                InputView(
//                    title: "이메일",
//                    placeholder: "이메일을 입력하세요",
//                    showRightButton: true,
//                    isRightButtonDisable: !intent.state.emailDoubleCheckButtonValidation,
//                    textFieldGetter: { intent.state.emailInputText },
//                    textFieldSetter: { intent.send(.write(inputKind: .email(input: $0))) },
//                    secureFieldGetter: { "" },
//                    secureFieldSetter: { _ in },
//                    rightButtonAction: { intent.send(.emailDoubleCheck) }
//                )
//                .keyboardType(.emailAddress)
//                
//                InputView(
//                    title: "닉네임",
//                    placeholder: "닉네임을 입력하세요",
//                    textFieldGetter: { intent.state.nicknameInputText },
//                    textFieldSetter: { intent.send(.write(inputKind: .nickname(input: $0))) },
//                    secureFieldGetter: { "" },
//                    secureFieldSetter: { _ in },
//                    rightButtonAction: {}
//                )
//                
//                InputView(
//                    title: "연락처",
//                    placeholder: "전화번호를 입력하세요",
//                    textFieldGetter: { intent.state.phoneNumberInputText },
//                    textFieldSetter: { intent.send(.write(inputKind: .phone(input: $0))) },
//                    secureFieldGetter: { "" },
//                    secureFieldSetter: { _ in },
//                    rightButtonAction: {}
//                )
//                .keyboardType(.numberPad)
//                
//                InputView(
//                    title: "비밀번호",
//                    placeholder: "비밀번호를 입력하세요",
//                    isSecure: true,
//                    textFieldGetter: { "" },
//                    textFieldSetter: { _ in },
//                    secureFieldGetter: { intent.state.passwordInputText },
//                    secureFieldSetter: { intent.send(.write(inputKind: .password(input: $0))) },
//                    rightButtonAction: {}
//                )
//                
//                InputView(
//                    title: "비밀번호 확인",
//                    placeholder: "비밀번호를 한 번 더 입력하세요",
//                    isSecure: true,
//                    textFieldGetter: { "" },
//                    textFieldSetter: { _ in },
//                    secureFieldGetter: { intent.state.passwordConfirmInputText },
//                    secureFieldSetter: { intent.send(.write(inputKind: .passwordConfirm(input: $0, password: intent.state.passwordInputText))) },
//                    rightButtonAction: {}
//                )
                
                Spacer()
                
                // TODO: - 키보드에 따라 버튼이 같이 올라가고 사라지는 기능 구현
                CustomButton {
                    print("가입하기")
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
