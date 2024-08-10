//
//  WorkspaceProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import Foundation

final class WorkspaceProvider: BaseProvider<WorkspaceService> {
    
    static let shared = WorkspaceProvider()
    
    private override init() {}
    
    func fetchWorkspaces() async throws -> [Workspace]? {
        return try await performRequest(.fetchWorkspaces, errorType: CommonError.self) { data in
            return try decode(data, as: [Workspace].self)
        }
    }
    
    func createWorkspace(name: String ,description: String?, image: ImageFile) async throws -> Workspace? {
        let createWorkspaceRequest = CreateWorkspaceRequest(name: name, description: description, image: image)
        return try await performRequest(.createWorkspace(request: createWorkspaceRequest), errorType: CreateWorkspaceError.self) { data in
            return try decode(data, as: Workspace.self)
        }
    }
    
    func fetchMyChannels(workspaceID: String) async throws -> [Channel]? {
        let fetchMyWorkspaceParams = FetchMyChannelsParams(workspaceID: workspaceID)
        return try await performRequest(.fetchMyChannels(params: fetchMyWorkspaceParams), errorType: FetchMyChannelsError.self) { data in
            return try decode(data, as: [Channel].self)
        }
    }
    
    func fetchMyDMRooms(workspaceID: String) async throws -> [DMRoom]? {
        let fetchDMRoomsParams = FetchDMRoomsParams(workspaceID: workspaceID)
        return try await performRequest(.fetchDMs(params: fetchDMRoomsParams), errorType: FetchDMsError.self) { data in
            return try decode(data, as: [DMRoom].self)
        }
    }
    
    func editWorkspace(workspaceId: String, name: String ,description: String?, image: ImageFile) async throws -> Workspace? {
        let editWorkspaceParams = EditWorkspaceParams(workspaceID: workspaceId)
        let editWorkspaceRequest = EditWorkspaceRequest(name: name, description: description, image: image)
        return try await performRequest(.editWorkspace(params: editWorkspaceParams, request: editWorkspaceRequest), errorType: EditWorkspaceError.self) { data in
            return try decode(data, as: Workspace.self)
        }
    }
    
    func deleteWorkspace(workspaceId: String) async throws -> Bool? {
        let deleteWorkspaceParams = DeleteWorkspaceParams(workspaceID: workspaceId)
        return try await performRequest(.deleteWorkspace(params: deleteWorkspaceParams), errorType: DeleteWorkspaceError.self) { data in
            print("워크스페이스가 성공적으로 삭제되었습니다.")
            return true
        }
    }
    
    func fetchWorkspaceMembers(workspaceID: String) async throws -> [WorkspaceMember]? {
        let fetchWorkspaceMembersParams = FetchWorkspaceMembersParams(workspaceID: workspaceID)
        return try await performRequest(.fetchWorkspaceMembers(params: fetchWorkspaceMembersParams), errorType: FetchWorkspaceMembersError.self) { data in
            return try decode(data, as: [WorkspaceMember].self)
        }
    }
    
    func transferWorkspaceOnwnership(workspaceID: String, memberID: String) async throws -> Workspace? {
        let transferWorkspaceOwnershipParams = TransferWorkspaceOwnershipParams(workspaceID: workspaceID)
        let transferWorkspaceOwnershipRequest = TransferWorkspaceOwnershipRequest(owner_id: memberID)
        return try await performRequest(.transferWorkspaceOwnership(params: transferWorkspaceOwnershipParams, request: transferWorkspaceOwnershipRequest), errorType: TransferWorkspaceOwnershipError.self) { data in
            return try decode(data, as: Workspace.self)
        }
    }
    
    func inviteMember(workspaceID: String, email: String) async throws -> WorkspaceMember? {
        let inviteMemberParams = InviteMemberParams(workspaceID: workspaceID)
        let inviteMemberRequest = InviteMemberRequest(email: email)
        return try await performRequest(.inviteMember(params: inviteMemberParams, request: inviteMemberRequest), errorType: InviteMemberError.self) { data in
            return try decode(data, as: WorkspaceMember.self)
        }
    }
    
    func leaveWorkspace(workspaceID: String) async throws -> [Workspace]? {
        let leaveWorkspaceParams = LeaveWorkspaceParams(workspaceID: workspaceID)
        return try await performRequest(.leaveWorkspace(params: leaveWorkspaceParams), errorType: LeaveWorkspaceError.self) { data in
            return try decode(data, as: [Workspace].self)
        }
    }
}
