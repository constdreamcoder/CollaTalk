//
//  LoginView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var store: AppStore
        
    @Binding var isPresented: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                NavigationBarForCreatingNewFeature(title: .login, isPresented: $isPresented)
                
                InputView(
                    title: "이메일",
                    placeholder: "이메일을 입력하세요",
                    textFieldGetter: { store.state.loginState.email },
                    textFieldSetter: { store.dispatch(.loginAction(.writeEmail(email: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {}
                )
                .keyboardType(.emailAddress)
                
                InputView(
                    title: "비밀번호",
                    placeholder: "비밀번호를 입력하세요",
                    isSecure: true,
                    textFieldGetter: { "" },
                    textFieldSetter: { _ in },
                    secureFieldGetter: { store.state.loginState.password },
                    secureFieldSetter: { store.dispatch(.loginAction(.writePassword(password: $0))) },
                    rightButtonAction: {}
                )
                
                Spacer()
                
                CustomButton {
                    print("로그인")
                    store.dispatch(.loginAction(.login))
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
