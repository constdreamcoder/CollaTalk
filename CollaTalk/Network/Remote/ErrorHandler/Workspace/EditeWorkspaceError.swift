//
//  EditeWorkspaceError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/18/24.
//

import Foundation

enum EditeWorkspaceError: String, LocalizedError {
    case badRequest = "E11"
    case duplicatedData = "E12"
    case noData = "E13"
    case noAccess = "E14"
  
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "올바르지 않은 접근입니다."
        case .duplicatedData:
            return "중복된 데이터입니다"
        case .noData:
            return "존재하지 않는 데이터입니다."
        case .noAccess:
            return "권한이 없습니다."
        }
    }
}
