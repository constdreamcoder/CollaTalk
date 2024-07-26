//
//  CreateWorkspaceError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/15/24.
//

import Foundation

enum CreateWorkspaceError: String, LocalizedError {
    case badRequest = "E11"
    case duplicatedData = "E12"
    case lackOfCoins = "E21"
  
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .duplicatedData:
            return "중복된 데이터입니다."
        case .lackOfCoins:
            return "코인이 부족합니다."
        }
    }
}
