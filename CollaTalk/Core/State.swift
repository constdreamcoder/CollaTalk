//
//  State.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

struct AppState {
    var loginState = LoginState()
}

struct LoginState {
    var email = ""
    var password = ""
}
