//
//  LeaveChannelParamsError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/1/24.
//

import Foundation

enum LeaveChannelParamsError: String, LocalizedError {
    case badRequest = "E11"
    case noData = "E13"
    case requestDenied = "E15"
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .noData:
            return "존재하지 않는 데이터입니다."
        case .requestDenied:
            return "네트워크 요청이 거절되었습니다."
        }
    }
}
