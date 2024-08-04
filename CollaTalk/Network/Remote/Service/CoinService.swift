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
}

extension CoinService: BaseService {
    var path: String {
        switch self {
        case .fetchCoinItemList:
            return "/store/item/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchCoinItemList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchCoinItemList:
            return .requestPlain
        }
    }
}

