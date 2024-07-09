//
//  State.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

struct AppState {
    var loginState = LoginState()
    var showToast: Bool = false
    var errorMessage: String = ""
    
    struct LoginState {
        var email = ""
        var password = ""
        var isEmailEmpty = true
        var isPWEmpty = true
        var isEmailValid = true
        var isPWValid = true
        
        mutating func initializeAllStates() {
            self.email = ""
            self.password = ""
            self.isEmailEmpty = true
            self.isPWEmpty = true
            self.isEmailValid = true
            self.isPWValid = true
        }
    }
}
