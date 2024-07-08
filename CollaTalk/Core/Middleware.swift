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
            print("login middleware")
            print("email: \(state.loginState.email), password: \(state.loginState.password)")
        case .writeEmail(let email): break
        case .writePassword(let password): break
        }
    }
    
    return Empty().eraseToAnyPublisher()
}


