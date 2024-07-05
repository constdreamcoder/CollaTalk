//
//  LoginView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var isPresented: Bool
    
    @State private var text = ""

    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                NavigationBarForCreatingNewFeature(title: .login, isPresented: $isPresented)
                
                InputView(
                    text: $text,
                    title: "이메일",
                    placeholder: "이메일을 입력하세요",
                    rightButtonAction: {}
                )
                .keyboardType(.emailAddress)
                
                InputView(
                    text: $text,
                    title: "비밀번호",
                    placeholder: "비밀번호를 입력하세요",
                    isSecure: true,
                    rightButtonAction: {}
                )
                
                Spacer()
                
                CustomButton {
                    print("로그인")
                } label: {
                    Text("로그인")
                }
                .bottomButtonShape(.brandGreen)
            }
        }
    }
}

#Preview {
    LoginView(isPresented: .constant(false))
}
