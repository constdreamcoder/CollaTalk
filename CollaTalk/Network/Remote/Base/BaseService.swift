//
//  BaseService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation
import Moya

protocol BaseService: TargetType { }

extension BaseService {
    var baseURL: URL {
        URL(string: APIKeys.baseURL)!
    }
    
    var headers: [String : String]? {
        [
            Headers.sesacKey.rawValue: APIKeys.sesacKey,
            Headers.authorization.rawValue: UserDefaultsManager.getObject(forKey: .userInfo, as: UserInfo.self)?.token.accessToken ?? ""
        ]
    }
}
