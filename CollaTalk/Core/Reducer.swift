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
        case .writeEmail(let email):
            mutatingState.loginState.email = email
        case .writePassword(let password):
            mutatingState.loginState.password = password
        case .moveToMainView:
            mutatingState.loginState.email = ""
            mutatingState.loginState.password = ""
        case .loginError(let errorMessage):
            print("로그인 에러")
            print("errorMessage", errorMessage)
            mutatingState.errorMessage = errorMessage
        default:
            break
        }
    }
    
    return mutatingState
}
