//
//  Actions.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

enum AppAction {
    case loginAction(LoginAction)
    case signUpAction(SignUpAction)
    case dismissToastMessage
    
    enum LoginAction {
        case login
        case writeEmail(email: String)
        case writePassword(password: String)
        case moveToMainView(userInfo: UserInfo)
        case isEmailEmpty(isEmpty: Bool)
        case isPWEmpty(isEmpty: Bool)
        case isValid(isEmailValid: Bool, isPWValid: Bool)
        case loginError(errorMesssage: String?)
        case intializeAllElements
    }
    
    enum SignUpAction {
        case writeEmail(email: String)
        case emailDoubleCheck
        case writeNickname(nickname: String)
        case writePhoneNumber(phoneNumber: String)
        case writePassword(password: String)
        case writePasswordForMatchCheck(passwordForMatchCheck: String)
        case join
    }
}
