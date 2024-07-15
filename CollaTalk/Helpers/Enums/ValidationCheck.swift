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
    case passwordForMatchCheck(input: String, password: String)
    case login(isValid: Bool)
    case nickname(input: String)
    case phoneNumber(input: String)
    case workspaceName(input: String)
    case workspaceCoverImage(input: Data)
    
    var validation: Bool {
        switch self {
        case .email(let email):
            return isValidEmail(email)
        case .password(let password):
            return isValidPassword(password)
        case .passwordForMatchCheck(let passwordForMatchCheck, let password):
            return isValidPasswordForMatchCheck(passwordForMatchCheck, with: password)
        case .login(let isValid):
            return isValid
        case .nickname(let nickname):
            return isValidNickname(nickname)
        case .phoneNumber(let phoneNumber):
            return isValidPhoneNumber(phoneNumber)
        case .workspaceName(let workspaceName):
            return isWorkspaceNameValid(workspaceName)
        case .workspaceCoverImage(let workspaceCoverImage):
            return isWorkspaceCoverImageValid(workspaceCoverImage)
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
    
    private func isValidNickname(_ input: String) -> Bool {
        return input.count >= 1 && input.count <= 30
    }
    
    private func isValidPhoneNumber(_ input: String) -> Bool {
        let regex = "^01\\d{8,9}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
    
    private func isValidPasswordForMatchCheck(_ input: String, with password: String) -> Bool {
        return input == password
    }
    
    private func isWorkspaceNameValid(_ input: String) -> Bool {
        return input.count >= 1 && input.count <= 30
    }
    
    private func isWorkspaceCoverImageValid(_ input: Data) -> Bool {
        return input.count > 0
    }
}
