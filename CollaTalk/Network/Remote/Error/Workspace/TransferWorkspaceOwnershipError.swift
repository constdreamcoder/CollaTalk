//
//  TransferWorkspaceOwnershipError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/20/24.
//

import Foundation

enum TransferWorkspaceOwnershipError: String, LocalizedError {
    case badRequest = "E11"
    case noData = "E13"
    case noAccess = "E14"
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .noData:
            return "존재하지 않는 데이터입니다."
        case .noAccess:
            return "권한이 없습니다."
        }
    }
}
