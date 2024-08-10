//
//  RefreshTokenService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/10/24.
//

import Foundation
import Moya

enum RefreshTokenService {
    case refreshToken
}

extension RefreshTokenService: BaseService {
    
    var path: String {
        switch self {
        case .refreshToken:
            return "/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .refreshToken:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .refreshToken:
            return .requestPlain
        }
    }
    
}
