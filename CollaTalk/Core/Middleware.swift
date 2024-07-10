//
//  Middleware.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Combine

typealias Middleware<State, Action> = (State, Action) -> AnyPublisher<Action, Never>

let userMiddleware: Middleware<AppState, AppAction> = { state, action in
    switch action {
    case .loginAction(let loginAction):
        switch loginAction {
            /// 로그인 버튼이 클릭된 경우
        case .login:
            /// 이메일 유효성 검사
            let isEmailValid = ValidationCheck.email(input: state.loginState.email).validation
            
            /// 비밀번호 유효성 검사
            let isPWValid = ValidationCheck.password(input: state.loginState.password).validation
            
            guard isEmailValid && isPWValid
            else {
                return Just(.loginAction(.isValid(isEmailValid: isEmailValid, isPWValid: isPWValid))).eraseToAnyPublisher()
            }
            
            /// 로그인
            return Future<AppAction, Never> { promise in
                Task {
                    do {
                        let userInfo = try await UserProvider.shared.login(
                            email: state.loginState.email,
                            password: state.loginState.password
                        )
                        guard let userInfo else { return }
                        UserDefaultsManager.setObject(userInfo, forKey: .userInfo)
                        promise(.success(.loginAction(.moveToMainView(userInfo: userInfo))))
                    } catch {
                        promise(.success(.loginAction(.loginError(errorMesssage: error.localizedDescription))))
                    }
                }
            }.eraseToAnyPublisher()
            /// 이메일가 입력되는 경우
        case .writeEmail(let email):
            return Just(.loginAction(.isEmailEmpty(isEmpty: email.isEmpty))).eraseToAnyPublisher()
            /// 비밀번호가 입력되는 경우
        case .writePassword(let password):
            return Just(.loginAction(.isPWEmpty(isEmpty: password.isEmpty))).eraseToAnyPublisher()
        default: break
        }
    case .dismissToastMessage: break
    case .signUpAction(let signUpAction):
        switch signUpAction {
        case .writeEmail(email: let email):
            break
        case .emailDoubleCheck:
            break
        case .writeNickname(nickname: let nickname):
            break
        case .writePhoneNumber(phoneNumber: let phoneNumber):
            break
        case .writePassword(password: let password):
            break
        case .writePasswordForMatchCheck(passwordForMatchCheck: let passwordForMatchCheck):
            break
        case .join:
            break
        }
        
    }
    
    return Empty().eraseToAnyPublisher()
}


