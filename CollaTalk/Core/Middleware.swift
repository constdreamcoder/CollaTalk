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
            
            Task {
                let userInfo = await UserProvider.shared.login(
                    email: state.loginState.email,
                    password: state.loginState.password
                )
                guard let userInfo else { return }
                UserDefaultsManager.setObject(userInfo, forKey: .userInfo)
            }
            return Just(.loginAction(.moveToMainView)).eraseToAnyPublisher()
        default: break
        }
    }
    
    return Empty().eraseToAnyPublisher()
}


