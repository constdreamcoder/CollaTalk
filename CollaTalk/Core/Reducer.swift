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
            mutatingState.loginState.isEmailEmpty = email.isEmpty
        case .writePassword(let password):
            mutatingState.loginState.password = password
            mutatingState.loginState.isPWEmpty = password.isEmpty
        case .moveToMainView(let userInfo):
            mutatingState.loginState.email = ""
            mutatingState.loginState.password = ""
            
            mutatingState.user = userInfo
            
        case .loginError(let errorMessage):
            mutatingState.toastMessage = ToastMessage.login(.failToLogin).message
            mutatingState.showToast = true
        case .isValid(let isEmailValid, let isPWValid):
            mutatingState.loginState.isEmailValid = isEmailValid
            mutatingState.loginState.isPWValid = isPWValid
            if !isEmailValid {
                mutatingState.toastMessage = ToastMessage.login(.emailValidationError).message
            } else if !isPWValid {
                mutatingState.toastMessage = ToastMessage.login(.passwordValidationError).message
            } else {
                mutatingState.toastMessage = ToastMessage.login(.etc).message
            }
            
            mutatingState.showToast = !isEmailValid || !isPWValid
        case .disappearView:
            mutatingState.showToast = false
            mutatingState.toastMessage = ""
            
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
            mutatingState.signUpState.isEmailEmpty = email.isEmpty
            mutatingState.signUpState.isEmailDoubleChecked = false
        case .writeNickname(let nickname):
            mutatingState.signUpState.nickname = nickname
            mutatingState.signUpState.isNicknameEmpty = nickname.isEmpty
        case .writePhoneNumber(let phoneNumber):
            mutatingState.signUpState.phoneNumber = phoneNumber
        case .writePassword(let password):
            mutatingState.signUpState.password = password
            mutatingState.signUpState.isPWEmpty = password.isEmpty
        case .writePasswordForMatchCheck(let passwordForMatchCheck):
            mutatingState.signUpState.passwordForMatchCheck = passwordForMatchCheck
            mutatingState.signUpState.isPWForMatchCheckEmpty = passwordForMatchCheck.isEmpty
        case .sendEmailValidation(let isValid):
            mutatingState.signUpState.isEmailDoubleChecked = isValid
            mutatingState.toastMessage = isValid ? ToastMessage.signUp(.emailAvailable).message : ToastMessage.signUp(.emailNotConfirmed).message
            
            mutatingState.showToast = true
        case .isValid(
            let isEmailValid,
            let isNicknameValid,
            let isPhoneNumberValid,
            let isPWValid,
            let isPWForMatchCheckValid):
            
            mutatingState.signUpState.isEmailValid = isEmailValid && mutatingState.signUpState.isEmailDoubleChecked
            mutatingState.signUpState.isNicknameValid = isNicknameValid
            mutatingState.signUpState.isPhoneNumberValid = isPhoneNumberValid
            mutatingState.signUpState.isPWValid = isPWValid
            mutatingState.signUpState.isPWForMatchCheckValid = isPWForMatchCheckValid
            
            if !isEmailValid || !mutatingState.signUpState.isEmailDoubleChecked {
                mutatingState.toastMessage = ToastMessage.signUp(.emailNotConfirmed).message
            } else if !isNicknameValid {
                mutatingState.toastMessage = ToastMessage.signUp(.nicknameValidationError).message
            } else if !isPhoneNumberValid {
                mutatingState.toastMessage = ToastMessage.signUp(.phoneNumberValidationError).message
            } else if !isPWValid {
                mutatingState.toastMessage = ToastMessage.signUp(.passwordValidationError).message
            } else if !isPWForMatchCheckValid {
                mutatingState.toastMessage = ToastMessage.signUp(.passwordForMatchCheckValidationError).message
            } else {
                mutatingState.toastMessage = ToastMessage.signUp(.etc).message
            }
            
            mutatingState.showToast = isEmailValid || isNicknameValid || isPhoneNumberValid || isPWValid || isPWForMatchCheckValid
        case .emailDoubleCheck, .join: break
        case .joinError(let error):
            
            if let error = error as? JoinError {
                if error == JoinError.duplicatedData {
                    mutatingState.toastMessage = ToastMessage.signUp(.joindAccount).message
                } else if error == JoinError.badRequest {
                    mutatingState.toastMessage = ToastMessage.signUp(.etc).message
                }
                mutatingState.showToast = true
            }
        case .moveToReadyToStartView(let userInfo):
            mutatingState.signUpState.email = ""
            mutatingState.signUpState.nickname = ""
            mutatingState.signUpState.phoneNumber = ""
            mutatingState.signUpState.password = ""
            mutatingState.signUpState.passwordForMatchCheck = ""
            
            mutatingState.user = userInfo
        }
    
    case .createWorkspaceAction(let createWorkspaceAction):
        switch createWorkspaceAction {
        case .writeName(let name):
            mutatingState.createWorkspaceState.name = name
        case .writeDescription(let description):
            mutatingState.createWorkspaceState.description = description
        }
    }
    
    return mutatingState
}
