//
//  Reducer.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

typealias Reducer<State, Action> = (State, Action) -> State

let appReducer: Reducer<AppState, AppAction> = { state, action in
    var mutatingState = state
    
    switch action {
    case .loginAction(let loginAction):
        switch loginAction {
        case .login:
            print("login in reducer")
        case .writeEmail(let email):
            mutatingState.loginState.email = email
        case .writePassword(let password):
            mutatingState.loginState.password = password
        }
    }
    
    return mutatingState
}
