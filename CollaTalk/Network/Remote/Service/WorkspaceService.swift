//
//  WorkspaceService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import Foundation
import Moya

enum WorkspaceService {
    case fetchWorkspaces
    
}

extension WorkspaceService: BaseService {
    
    var path: String {
        switch self {
        case .fetchWorkspaces:
            return "/workspaces"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchWorkspaces:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchWorkspaces:
            return .requestPlain
        }
    }
    
}
