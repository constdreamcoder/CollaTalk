//
//  DeleteWorkspaceError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/20/24.
//

import Foundation

enum DeleteWorkspaceError: String, LocalizedError {
    case noData = "E13"
    case noAccess = "E14"
  
    var errorDescription: String? {
        switch self {
        case .noData:
            return "존재하지 않는 데이터입니다."
        case .noAccess:
            return "권한이 없습니다."
        }
    }
}
