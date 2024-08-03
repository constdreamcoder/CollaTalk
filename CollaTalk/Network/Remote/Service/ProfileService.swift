//
//  ProfileService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/3/24.
//

import Foundation
import Moya

enum ProfileService {
   case fetchMyProfile
}

extension ProfileService: BaseService {
    var path: String {
        switch self {
        case .fetchMyProfile:
            return "/users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMyProfile:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchMyProfile:
            return .requestPlain
        }
    }
}

