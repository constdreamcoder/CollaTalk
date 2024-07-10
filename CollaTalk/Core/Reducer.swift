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
            mutatingState.errorMessage = "에러가 발생했어요. 잠시 후 다시 시도해주세요."
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
            
            mutatingState.showToast = !isEmailValid || !isPWValid
        case .disappearView:
            mutatingState.showToast = false
            mutatingState.errorMessage = ""
            
            mutatingState.loginState.initializeAllStates()
            
        case .login:
            break
        }
        
    case .dismissToastMessage:
        mutatingState.showToast = false
    case .signUpAction(let signUpAction):
        switch signUpAction {
        case .writeEmail(let email):
            mutatingState.signUpState.email = email
            mutatingState.signUpState.isEmailEmpty = email == "" ? true : false
        case .writeNickname(let nickname):
            mutatingState.signUpState.nickname = nickname
        case .writePhoneNumber(let phoneNumber):
            mutatingState.signUpState.phoneNumber = phoneNumber
        case .writePassword(let password):
            mutatingState.signUpState.password = password
        case .writePasswordForMatchCheck(let passwordForMatchCheck):
            mutatingState.signUpState.passwordForMatchCheck = passwordForMatchCheck
        case .emailDoubleCheck, .join: break
        case .sendEmailValidation(let isValid):
            mutatingState.signUpState.isEmailValid = isValid
            mutatingState.errorMessage = ValidationCheck.email(input: state.signUpState.email).validationMessage
            mutatingState.showToast = !isValid
        }
    }
    
    return mutatingState
}
