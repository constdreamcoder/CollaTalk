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
    case createWorkspace(request: CreateWorkspaceRequest)
    case fetchMyChannels(params: FetchMyChannelsParams)
}

extension WorkspaceService: BaseService {
    
    var path: String {
        switch self {
        case .fetchWorkspaces, .createWorkspace:
            return "/workspaces"
        case .fetchMyChannels(let paramas):
            return "/workspaces/\(paramas)/my-channels"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchWorkspaces, .fetchMyChannels:
            return .get
        case .createWorkspace:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchWorkspaces, .fetchMyChannels:
            return .requestPlain
        case .createWorkspace(let request):
            return .uploadMultipart([
                MultipartFormData(
                    provider: .data(request.name.data(using: .utf8) ?? Data()),
                    name: MultiPartFormKey.name
                ),
                MultipartFormData(
                    provider: .data(request.description?.data(using: .utf8) ?? Data()),
                    name: MultiPartFormKey.description
                ),
                MultipartFormData(
                    provider: .data(request.image.imageData),
                    name: MultiPartFormKey.image,
                    fileName: request.image.name,
                    mimeType: request.image.mimeType.rawValue
                )
            ])
        }
    }
    
}
