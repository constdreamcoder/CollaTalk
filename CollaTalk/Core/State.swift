//
//  State.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

struct AppState {
    var loginState = LoginState()
    var errorMessage: String? = nil
}

struct LoginState {
    var email = ""
    var password = ""
    var isEmailEmpty = true
    var isPWEmpty = true
    var isEmailValid = true
    var isPWValid = true
}
