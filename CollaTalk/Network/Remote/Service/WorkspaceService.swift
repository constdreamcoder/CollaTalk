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
    case fetchDMs(params: FetchDMsParams)
    case editWorkspace(params: EditWorkspaceParams, request: EditWorkspaceRequest)
    case deleteWorkspace(params: DeleteWorkspaceParams)
    case fetchWorkspaceMembers(params: FetchWorkspaceMembersParams)
}

extension WorkspaceService: BaseService {
    
    var path: String {
        switch self {
        case .fetchWorkspaces, .createWorkspace:
            return "/workspaces"
        case .fetchMyChannels(let paramas):
            return "/workspaces/\(paramas.workspaceID)/my-channels"
        case .fetchDMs(let params):
            return "/workspaces/\(params.workspaceID)/dms"
        case .editWorkspace(let params, _):
            return "/workspaces/\(params.workspaceID)"
        case .deleteWorkspace(let params):
            return "/workspaces/\(params.workspaceID)"
        case .fetchWorkspaceMembers(let params):
            return "/workspaces/\(params.workspaceID)/members"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchWorkspaces, .fetchMyChannels, .fetchDMs, .fetchWorkspaceMembers:
            return .get
        case .createWorkspace:
            return .post
        case .editWorkspace:
            return .put
        case .deleteWorkspace:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchWorkspaces, .fetchMyChannels, .fetchDMs, .deleteWorkspace, .fetchWorkspaceMembers:
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
        case .editWorkspace(_, let request):
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
