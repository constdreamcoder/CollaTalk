//
//  DMService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/25/24.
//

import Foundation
import Moya

enum DMService {
    case createOrFetchChatRoom(params: CreateOrFetchChatRoomParams, request: CreateOrFetchChatRoomRequest)
}

extension DMService: BaseService {
    var path: String {
        switch self {
        case .createOrFetchChatRoom(let params, _):
            return "/workspaces/\(params.workspaceID)/dms"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createOrFetchChatRoom:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createOrFetchChatRoom(_, let request):
            return .requestJSONEncodable(request)
        }
    }
}
