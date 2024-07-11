//
//  Actions.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

enum AppAction {
    case navigationAction(NavigationAction)
    case loginAction(LoginAction)
    case signUpAction(SignUpAction)
    case createWorkspaceAction(CreateWorkspaceAction)
    case dismissToastMessage
    
    enum NavigationAction {
        case presentBottomSheet(present: Bool)
        case presentLoginView(present: Bool)
        case presentSignUpView(present: Bool)
        case presentCreateWorkspaceView(present: Bool)
    }
    
    enum LoginAction {
        case login
        case writeEmail(email: String)
        case writePassword(password: String)
        case moveToMainView(userInfo: UserInfo)
        case isValid(isEmailValid: Bool, isPWValid: Bool)
        case loginError(errorMesssage: String?)
        case disappearView
    }
    
    enum SignUpAction {
        case writeEmail(email: String)
        case emailDoubleCheck
        case writeNickname(nickname: String)
        case writePhoneNumber(phoneNumber: String)
        case writePassword(password: String)
        case writePasswordForMatchCheck(passwordForMatchCheck: String)
        case join
        case sendEmailValidation(isValid: Bool)
        case isValid(isEmailValid: Bool, isNicknameValid: Bool, isPhoneNumberValid: Bool, isPWValid: Bool, isPWForMatchCheckValid: Bool)
        case joinError(Error)
        case moveToReadyToStartView(userInfo: UserInfo)
    }
    
    enum CreateWorkspaceAction {
        case writeName(name: String)
        case writeDescription(description: String)
    }
}
