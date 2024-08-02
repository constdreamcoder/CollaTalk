//
//  LeaveWorkspaceError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/2/24.
//

import Foundation

enum LeaveWorkspaceError: String, LocalizedError {
    case noData = "E13"
    case requestDenied = "E15"

    var errorDescription: String? {
        switch self {
        case .noData:
            return "존재하지 않는 데이터입니다."
        case .requestDenied:
            return "네트워크 요청이 거절되었습니다."
        }
    }
}

