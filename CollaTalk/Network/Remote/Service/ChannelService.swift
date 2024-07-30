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
    case sendChannelChat(params: SendChannelChatParams, request: SendChannelChatRequest)
}

extension ChannelService: BaseService {
    var path: String {
        switch self {
        case .fetchChannelChats(let params, _):
            return "/workspaces/\(params.workspaceID)/channels/\(params.channelID)/chats"
        case .sendChannelChat(let params, _):
            return "/workspaces/\(params.workspaceID)/channels/\(params.channelID)/chats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchChannelChats:
            return .get
        case .sendChannelChat:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchChannelChats(_, let queries):
            return .requestParameters(
                parameters: [QueryKey.cursorDate: queries.cursorDate ?? ""],
                encoding: URLEncoding.default
            )
        case .sendChannelChat(_, let request):
            
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
        }
    }
}
