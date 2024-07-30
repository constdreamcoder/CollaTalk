//
//  ChannelService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/29/24.
//


import Foundation
import Moya

enum ChannelService {
    case fetchChannelChats(params: FetchChannelChatsParams, queries: FetchChannelChatsQuery)
}

extension ChannelService: BaseService {
    var path: String {
        switch self {
        case .fetchChannelChats(let params, _):
            return "/workspaces/\(params.workspaceID)/channels/\(params.channelID)/chats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchChannelChats:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchChannelChats(_, let queries):
            return .requestParameters(
                parameters: [QueryKey.cursorDate: queries.cursorDate ?? ""],
                encoding: URLEncoding.default
            )
        }
    }
}
