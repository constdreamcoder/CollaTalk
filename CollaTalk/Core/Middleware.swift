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
        /// 로그인
        case .login:
            // TODO: - 이메일 유효성 검사
            // TODO: - 비밀번호 유효성 검사

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
        case .writeEmail(let email):
            return Just(.loginAction(.isEmailEmpty(isEmpty: email.isEmpty))).eraseToAnyPublisher()
        case .writePassword(let password):
            return Just(.loginAction(.isPWEmpty(isEmpty: password.isEmpty))).eraseToAnyPublisher()
        default: break
        }
    }
    
    return Empty().eraseToAnyPublisher()
}


