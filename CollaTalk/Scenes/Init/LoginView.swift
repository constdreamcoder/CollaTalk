//
//  LoginView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @EnvironmentObject private var store: AppStore
        
    // TODO: - 유효성 검사 오류시 해당 TextField Focus되게 구현
    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                SheetNavigation(
                    title: .login,
                    isPresented: Binding(
                        get: { store.state.navigationState.isLoginViewPresented },
                        set: { store.dispatch(.navigationAction(.presentLoginView(present: $0)))
                        }
                    ), 
                    transitionAction: {}
                )
                
                InputView(
                    title: "이메일",
                    placeholder: "이메일을 입력하세요",
                    textFieldGetter: { store.state.loginState.email },
                    textFieldSetter: { store.dispatch(.loginAction(.writeEmail(email: $0))) },
                    secureFieldGetter: { "" },
                    secureFieldSetter: { _ in },
                    rightButtonAction: {},
                    isValid: store.state.loginState.isEmailValid
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
                    rightButtonAction: {},
                    isValid: store.state.loginState.isPWValid
                )
                
                Spacer()
                
                CustomButton {
                    print("로그인")
                    store.dispatch(.loginAction(.login))
                } label: {
                    Text("로그인")
                }
                .disabled(!isLoginButtonValid)
                .bottomButtonShape(isLoginButtonValid ? .brandGreen : .brandInactive)
            }
        }
        .onDisappear {
            print("disappear")
            store.dispatch(.loginAction(.disappearView))
        }
    }
}

extension LoginView {
    private var isLoginButtonValid: Bool {
        !store.state.loginState.isEmailEmpty
        && !store.state.loginState.isPWEmpty
    }
}

#Preview {
    LoginView()
}
