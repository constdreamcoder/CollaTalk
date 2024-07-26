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
    case sendDirectMessage(params: SendDirectMessageParams, request: SendDirectMessageRequest)
    case fetchDMHistory(params: FetchDMHistoryParams, query: FetchDMHistoryQuery)
    case fetchUnreadDMCount(params: FetchUnreadDMCountParams, query: FetchUnreadDMCountQuery)
}

extension DMService: BaseService {
    var path: String {
        switch self {
        case .createOrFetchChatRoom(let params, _):
            return "/workspaces/\(params.workspaceID)/dms"
        case .sendDirectMessage(let params, _):
            return "/workspaces/\(params.workspaceID)/dms/\(params.roomID)/chats"
        case .fetchDMHistory(let params, _):
            return "/workspaces/\(params.workspaceID)/dms/\(params.roomID)/chats"
        case .fetchUnreadDMCount(let params, _):
            return "/workspaces/\(params.workspaceID)/dms/\(params.roomID)/unreads"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createOrFetchChatRoom, .sendDirectMessage:
            return .post
        case .fetchDMHistory, .fetchUnreadDMCount:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .createOrFetchChatRoom(_, let request):
            return .requestJSONEncodable(request)
        case .sendDirectMessage(_, let request):
            
            var multipartList: [MultipartFormData] = [
                MultipartFormData(
                    provider: .data(request.content?.data(using: .utf8) ?? Data()),
                    name: MultiPartFormKey.content
                )
            ]
            
            let imageFilesMultipart: [MultipartFormData] = request.files?.map { imageFile in
                MultipartFormData(
                    provider: .data(imageFile.imageData),
                    name: MultiPartFormKey.files,
                    fileName: imageFile.name,
                    mimeType: imageFile.mimeType.rawValue
                )
            } ?? []
            
            multipartList = multipartList + imageFilesMultipart
            return .uploadMultipart(multipartList)
        case .fetchDMHistory(_, let queries):
            return .requestParameters(
                parameters: [QueryKey.cursorDate: queries.cursorDate ?? ""],
                encoding: URLEncoding.queryString
            )
        case .fetchUnreadDMCount(_, let queries):
            return .requestParameters(
                parameters: [QueryKey.after: queries.after ?? ""],
                encoding: URLEncoding.queryString
            )
        }
    }
}
