//
//  ChangeProfileInfoError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/4/24.
//

import Foundation

enum ChangeProfileInfoError: String, LocalizedError {
    case badRequest = "E11"
  
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        }
    }
}

