//
//  JoinError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/10/24.
//

import Foundation

enum JoinError: String, LocalizedError {
    case badRequest = "E11"
    case duplicatedData = "E12"
  
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .duplicatedData:
            return "중복된 데이터입니다."
        }
    }
}
