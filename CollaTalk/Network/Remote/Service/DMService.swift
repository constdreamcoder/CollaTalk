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
}

extension DMService: BaseService {
    var path: String {
        switch self {
        case .createOrFetchChatRoom(let params, _):
            return "/workspaces/\(params.workspaceID)/dms"
        case .sendDirectMessage(let params, _):
            return "/workspaces/\(params.workspaceID)/dms/\(params.roomID)/chats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createOrFetchChatRoom, .sendDirectMessage:
            return .post
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
        }
    }
}
