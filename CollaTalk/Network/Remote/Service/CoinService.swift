//
//  CoinService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/4/24.
//

import Foundation
import Moya

enum CoinService {
   case fetchCoinItemList
    case paymentValidation(request: PaymentValidationRequest)
}

extension CoinService: BaseService {
    var path: String {
        switch self {
        case .fetchCoinItemList:
            return "/store/item/list"
        case .paymentValidation:
            return "store/pay/validation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchCoinItemList:
            return .get
        case .paymentValidation:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchCoinItemList:
            return .requestPlain
        case .paymentValidation(let request):
            return.requestJSONEncodable(request)
        }
    }
}

