//
//  CommonError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/9/24.
//

import Foundation

extension Error {
    var asOriginalError: Self {
        print("original Error type", self)
        return self as Self
    }
}

enum CommonError: String, LocalizedError {
    case invalidAccessAuthorization = "E01"
    case unknownRouterRoute = "E97"
    case expiredAccessToken = "E05"
    case invalidToken = "E02"
    case unknownUser = "E03"
    case excesssiveCalls = "E98"
    case serverError = "E99"
    
    var errorDescription: String? {
        switch self {
        case .invalidAccessAuthorization:
            return "올바르지 않은 접근입니다."
        case .unknownRouterRoute:
            return "알 수 없는 경로입니다."
        case .expiredAccessToken:
            return "만료된 토큰입니다."
        case .invalidToken:
            return "인증에 실패하였습니다."
        case .unknownUser:
            return "알 수 없는 유저입니다."
        case .excesssiveCalls:
            return "네트워크가 과도하게 호출되었습니다."
        case .serverError:
            return "서버 오류"
        }
    }
}
