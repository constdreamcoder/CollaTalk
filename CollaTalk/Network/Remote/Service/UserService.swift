//
//  UserService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation
import Moya

enum UserService {
    case login(request: LoginRequest)
    case validateEmail(request: EmailValidationRequest)
    case join(request: JoinRequest)
}

extension UserService: BaseService {
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .validateEmail:
            return "/users/validation/email"
        case .join:
            return "/users/join"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validateEmail, .login, .join:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        case .validateEmail(let request):
            return .requestJSONEncodable(request)
        case .join(let request):
            return .requestJSONEncodable(request)
        }
    }
    
}
