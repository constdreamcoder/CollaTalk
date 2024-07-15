//
//  ToastMessage.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/10/24.
//

import Foundation

protocol ToastMessageType {
    var message: String { get }
}

enum ToastMessage: ToastMessageType {
    case login(Login)
    case signUp(SignUp)
    case addWorkspace(AddWorkspace)
    
    var message: String {
        switch self {
        case .login(let login):
            return login.message
        case .signUp(let signUp):
            return signUp.message
        case .addWorkspace(let addWorkspace):
            return addWorkspace.message
        }
    }
    
    enum Login: ToastMessageType {
        case emailValidationError
        case passwordValidationError
        case failToLogin
        case etc
        
        var message: String {
            switch self {
            case .emailValidationError:
                return "이메일 형식이 올바르지 않습니다."
            case .passwordValidationError:
                return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요."
            case .failToLogin:
                return "이메일 또는 비밀번호가 올바르지 않습니다."
            case .etc:
                return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
            }
        }
    }
    
    enum SignUp: ToastMessageType {
        case emailValidationError
        case emailAvailable
        case emailAlreadyConfirmed
        case emailNotConfirmed
        case nicknameValidationError
        case phoneNumberValidationError
        case passwordValidationError
        case passwordForMatchCheckValidationError
        case joindAccount
        case etc
        
        var message: String {
            switch self {
            case .emailValidationError:
                return "이메일 형식이 올바르지 않습니다."
            case .emailAvailable:
                return "사용 가능한 이메일입니다."
            case .emailAlreadyConfirmed:
                return "사용 가능한 이메일입니다."
            case .emailNotConfirmed:
                return "이메일 중복 확인을 진행해주세요."
            case .nicknameValidationError:
                return "닉네임은 1글자 이상 30글자 이내로 부탁드려요."
            case .phoneNumberValidationError:
                return "잘못된 전화번호 형식입니다."
            case .passwordValidationError:
                return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자/숫자/특수 문자를 설정해주세요."
            case .passwordForMatchCheckValidationError:
                return "작성하신 비밀번호가 일치하지 않습니다."
            case .joindAccount:
                return "이미 가입된 회원입니다. 로그인을 진행해주세요."
            case .etc:
                return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
            }
        }
    }
    
    enum AddWorkspace: ToastMessageType {
        case workspaceNameError
        case noImage
        
        var message: String {
            switch self {
            case .workspaceNameError:
                return "워크스페이스 이름은 1~30자로 설정해주세요."
            case .noImage:
                return "워크스페이스 이미지를 등록해주세요."
            }
        }
        
    }
}
