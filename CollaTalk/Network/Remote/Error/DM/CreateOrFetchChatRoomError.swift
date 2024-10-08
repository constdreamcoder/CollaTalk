//
//  CreateOrFetchChatRoomError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/25/24.
//

import Foundation

enum CreateOrFetchChatRoomError: String, LocalizedError {
    case badRequest = "E11"
    case noData = "E13"
  
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .noData:
            return "존재하지 않는 데이터입니다."
        }
    }
}
