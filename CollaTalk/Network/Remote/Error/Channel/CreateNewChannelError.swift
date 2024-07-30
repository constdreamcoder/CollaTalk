//
//  CreateNewChannelError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/30/24.
//

import Foundation

enum CreateNewChannelError: String, LocalizedError {
    case badRequest = "E11"
    case duplicatedData = "E12"
    case noData = "E13"
  
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .duplicatedData:
            return "중복된 데이터입니다."
        case .noData:
            return "존재하지 않는 데이터입니다."
        }
    }
}
