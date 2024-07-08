//
//  Actions.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

enum AppAction {
    case loginAction(LoginAction)
}

enum LoginAction {
    case login
    case writeEmail(email: String)
    case writePassword(password: String)
    case moveToMainView(userInfo: UserInfo)
    case loginError(errorMesssage: String)
}
