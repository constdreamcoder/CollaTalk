//
//  PaymentValidationError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/5/24.
//

import Foundation

enum PaymentValidationError: String, LocalizedError {
    case badRequest = "E11"
    case nonExistingPayment = "E81"
    case invalidPayment = "E82"
  
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다."
        case .nonExistingPayment:
            return "존재하지 않는 결제건입니다."
        case .invalidPayment:
            return "유효하지 않은 결제건입니다."
        }
    }
}
