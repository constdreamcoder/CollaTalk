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
            mutatingState.errorMessage = "에러가 발생했어요. 잠시 후 다시 시도해주세요."
            print("errorMessage", mutatingState.errorMessage)
            mutatingState.showToast = true
        case .isEmailEmpty(let isEmpty):
            mutatingState.loginState.isEmailEmpty = isEmpty
        case .isPWEmpty(let isEmpty):
            mutatingState.loginState.isPWEmpty = isEmpty
        case .isValid(let isEmailValid, let isPWValid):
            mutatingState.loginState.isEmailValid = isEmailValid
            mutatingState.loginState.isPWValid = isPWValid
            if !isEmailValid && !isPWValid {
                mutatingState.errorMessage = ValidationCheck.login(isValid: isEmailValid && isPWValid).validationMessage
            } else if !isEmailValid {
                mutatingState.errorMessage = ValidationCheck.email(input: state.loginState.email).validationMessage
            } else if !isPWValid {
                mutatingState.errorMessage = ValidationCheck.password(input: state.loginState.password).validationMessage
            }
            
            mutatingState.showToast = true
            print("errorMessage", mutatingState.errorMessage)
        case .intializeAllElements:
            mutatingState.showToast = false
            mutatingState.errorMessage = ""
            
            mutatingState.loginState.initializeAllStates()
            
        case .login:
            break
        }
        
    case .dismissToastMessage:
        mutatingState.showToast = false
    }
    
    return mutatingState
}
