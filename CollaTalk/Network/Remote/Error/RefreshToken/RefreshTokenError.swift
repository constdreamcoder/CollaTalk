//
//  RefreshTokenError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/9/24.
//

import Foundation

enum RefreshTokenError: String, LocalizedError {
    case expiredRefreshToken = "E06"
  
    var errorDescription: String? {
        switch self {
        case .expiredRefreshToken:
            return "Refresh 토큰이 만료되었습니다."
        }
    }
}
