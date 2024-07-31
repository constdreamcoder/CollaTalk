//
//  ChannelService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/29/24.
//


import Foundation
import Moya

enum ChannelService {
    case fetchChannelChats(params: FetchChannelChatsParams, query: FetchChannelChatsQuery)
    case sendChannelChat(params: SendChannelChatParams, request: SendChannelChatRequest)
    case fetchUnreadChannelChats(params: FetchUnreadChannelChatsParams, query: FetchUnreadChannelQuery)
    case createNewChannel(params: CreateNewChannelParams, request: CreateNewChannelRequest)
    case fetchAllChannels(params: FetchAllChannelsParams)
    case fetchChannelDetails(params: FetchChannelDetailsParams)
    case editChannelDetails(params: EditChannelDetailsParams, request: EditChannelDetailsRequest)
}

extension ChannelService: BaseService {
    var path: String {
        switch self {
        case .fetchChannelChats(let params, _):
            return "/workspaces/\(params.workspaceID)/channels/\(params.channelID)/chats"
        case .sendChannelChat(let params, _):
            return "/workspaces/\(params.workspaceID)/channels/\(params.channelID)/chats"
        case .fetchUnreadChannelChats(let params, _):
            return "/workspaces/\(params.workspaceID)/channels/\(params.channelID)/unreads"
        case .createNewChannel(let params, _):
            return "/workspaces/\(params.workspaceID)/channels"
        case .fetchAllChannels(let params):
            return "/workspaces/\(params.workspaceID)/channels"
        case .fetchChannelDetails(let params):
            return "/workspaces/\(params.workspaceID)/channels/\(params.channelID)"
        case .editChannelDetails(let params, _):
            return "/workspaces/\(params.workspaceID)/channels/\(params.channelID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchChannelChats, .fetchUnreadChannelChats, .fetchAllChannels, .fetchChannelDetails:
            return .get
        case .sendChannelChat, .createNewChannel:
            return .post
        case .editChannelDetails:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchChannelChats(_, let query):
            return .requestParameters(
                parameters: [QueryKey.cursorDate: query.cursorDate ?? ""],
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
        case .fetchUnreadChannelChats(_, let query):
            return .requestParameters(
                parameters: [QueryKey.after: query.after ?? ""],
                encoding: URLEncoding.default
            )
        case .createNewChannel(_, let request):
            let dataMultipart: [MultipartFormData] = [
                MultipartFormData(
                    provider: .data(request.name.data(using: .utf8) ?? Data()),
                    name: MultiPartFormKey.name
                ),
                MultipartFormData(
                    provider: .data(request.description?.data(using: .utf8) ?? Data()),
                    name: MultiPartFormKey.description
                )
            ]
            
            let imageFile = request.image
            let imageFilesMultipart = [
                MultipartFormData(
                    provider: .data(imageFile?.imageData ?? Data()),
                    name: MultiPartFormKey.image,
                    fileName: imageFile?.name,
                    mimeType: imageFile?.mimeType.rawValue
                )
            ]
            
            let multipartList = dataMultipart + imageFilesMultipart
            return .uploadMultipart(multipartList)
        case .fetchAllChannels, .fetchChannelDetails:
            return .requestPlain
        case .editChannelDetails(_, let request):
            let dataMultipart: [MultipartFormData] = [
                MultipartFormData(
                    provider: .data(request.name.data(using: .utf8) ?? Data()),
                    name: MultiPartFormKey.name
                ),
                MultipartFormData(
                    provider: .data(request.description?.data(using: .utf8) ?? Data()),
                    name: MultiPartFormKey.description
                )
            ]
            
            let imageFile = request.image
            let imageFilesMultipart = [
                MultipartFormData(
                    provider: .data(imageFile?.imageData ?? Data()),
                    name: MultiPartFormKey.image,
                    fileName: imageFile?.name,
                    mimeType: imageFile?.mimeType.rawValue
                )
            ]
            
            let multipartList = dataMultipart + imageFilesMultipart
            return .uploadMultipart(multipartList)
        }
    }
}
