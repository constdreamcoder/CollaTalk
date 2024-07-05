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
                
                InputView(
                    text: $text,
                    title: "이메일",
                    placeholder: "이메일을 입력하세요",
                    showRightButton: true,
                    rightButtonAction: {}
                )
                .keyboardType(.emailAddress)
                
                InputView(
                    text: $text,
                    title: "닉네임",
                    placeholder: "닉네임을 입력하세요",
                    rightButtonAction: {}
                )
                
                InputView(
                    text: $text,
                    title: "연락처",
                    placeholder: "전화번호를 입력하세요",
                    rightButtonAction: {}
                )
                .keyboardType(.numberPad)
                
                InputView(
                    text: $text,
                    title: "비밀번호",
                    placeholder: "비밀번호를 입력하세요",
                    isSecure: true,
                    rightButtonAction: {}
                )
                
                InputView(
                    text: $text,
                    title: "비밀번호 확인",
                    placeholder: "비밀번호를 한 번 더 입력하세요",
                    isSecure: true,
                    rightButtonAction: {}
                )
                
                Spacer()
                
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
