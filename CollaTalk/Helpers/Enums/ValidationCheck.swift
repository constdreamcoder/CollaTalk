//
//  ValidationCheck.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/9/24.
//

import Foundation

enum ValidationCheck {
    case email(input: String)
    case password(input: String)
    case login(isValid: Bool)
    
    var validation: Bool {
        switch self {
        case .email(let email):
            return isValidEmail(email)
        case .password(let password):
            return isValidPassword(password)
        case .login(let isValid):
            return isValid
        }
    }
    
    var validationMessage: String? {
        switch self {
        case .email(let email):
            return isValidEmail(email) ? nil : "이메일 형식이 올바르지 않습니다."
        case .password(let password):
            return isValidPassword(password) ? nil : "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요."
        case .login(let isValid):
            return isValid ? nil : "이메일 또는 비밀번호가 올바르지 않습니다."
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        guard password.count >= 8 else {
            return false
        }
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
}
