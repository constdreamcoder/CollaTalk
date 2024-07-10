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
            self.isEmailValid = true // TODO: - 가독성을 위해 초기값 false 일때로 변경 필요
            self.isPWValid = true // TODO: - 가독성을 위해 초기값 false 일때로 변경 필요
        }
    }
    
    struct SignUpState {
        var email: String = ""
        var nickname: String = ""
        var phoneNumber: String = ""
        var password: String = ""
        var passwordForMatchCheck: String = ""
        var isEmailValid: Bool = false
        var isEmailEmpty: Bool = true
        var isNicknameEmpty: Bool = true
        var isPWEmpty: Bool = true
        var isPWForMatchCheckEmpty: Bool = true
    }
}
