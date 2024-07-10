//
//  State.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

struct AppState {
    
    var showToast: Bool = false
    var errorMessage: String = ""
    
    var loginState = LoginState()
    var signUpState = SignUpState()
   
    struct LoginState {
        var email: String = ""
        var password: String = ""
        var isEmailEmpty: Bool = true
        var isPWEmpty: Bool = true
        var isEmailValid: Bool = true
        var isPWValid: Bool = true
        
        mutating func initializeAllStates() {
            self.email = ""
            self.password = ""
            self.isEmailEmpty = true
            self.isPWEmpty = true
            self.isEmailValid = true
            self.isPWValid = true
        }
    }
    
    struct SignUpState {
        var email: String = ""
        var nickname: String = ""
        var phoneNumber: String = ""
        var password: String = ""
        var passwordForMatchCheck: String = ""
    }
}
