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
        case .login:
            print("email: \(state.loginState.email), password: \(state.loginState.password)")
            Task {
                let userInfo = await UserProvider.shared.login(email:state.loginState.email, password: state.loginState.password)
                guard let userInfo else { return }
            }
            return Just(.loginAction(.clearLoginInfo)).eraseToAnyPublisher()
        case .writeEmail(let email): break
        case .writePassword(let password): break
        case .clearLoginInfo: break
        }
    }
    
    return Empty().eraseToAnyPublisher()
}


