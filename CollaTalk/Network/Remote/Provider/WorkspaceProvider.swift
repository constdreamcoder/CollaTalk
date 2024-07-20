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
        do {
            let response = try await request(.fetchWorkspaces)
            switch response.statusCode {
            case 200:
                let workspaces = try decode(response.data, as: [Workspace].self)
                return workspaces
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func createWorkspace(name: String ,description: String?, image: ImageFile) async throws -> Workspace? {
        let createWorkspaceRequest = CreateWorkspaceRequest(name: name, description: description, image: image)
        do {
            let response = try await request(.createWorkspace(request: createWorkspaceRequest))
            switch response.statusCode {
            case 200:
                let newWorkspace = try decode(response.data, as: Workspace.self)
                return newWorkspace
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let createWorkspaceError = CreateWorkspaceError(rawValue: errorCode.errorCode) {
                    throw createWorkspaceError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func fetchMyChannels(workspaceID: String) async throws -> [Channel]? {
        let fetchMyWorkspaceParams = FetchMyChannelsParams(workspaceID: workspaceID)
        do {
            let response = try await request(.fetchMyChannels(params: fetchMyWorkspaceParams))
            switch response.statusCode {
            case 200:
                let myChannels = try decode(response.data, as: [Channel].self)
                return myChannels
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let fetchMyChannelsError = FetchMyChannelsError(rawValue: errorCode.errorCode) {
                    throw fetchMyChannelsError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func fetchMyDMs(workspaceID: String) async throws -> [DM]? {
        let fetchDMsParams = FetchDMsParams(workspaceID: workspaceID)
        do {
            let response = try await request(.fetchDMs(params: fetchDMsParams))
            switch response.statusCode {
            case 200:
                let dms = try decode(response.data, as: [DM].self)
                return dms
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let fetchDMsError = FetchDMsError(rawValue: errorCode.errorCode) {
                    throw fetchDMsError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func editWorkspace(workspaceId: String, name: String ,description: String?, image: ImageFile) async throws -> Workspace? {
        let editWorkspaceParams = EditWorkspaceParams(workspaceID: workspaceId)
        let editWorkspaceRequest = EditWorkspaceRequest(name: name, description: description, image: image)
        do {
            let response = try await request(.editWorkspace(params: editWorkspaceParams, request: editWorkspaceRequest))
            switch response.statusCode {
            case 200:
                let newWorkspace = try decode(response.data, as: Workspace.self)
                return newWorkspace
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let editeWorkspaceError = EditWorkspaceError(rawValue: errorCode.errorCode) {
                    throw editeWorkspaceError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func deleteWorkspace(workspaceId: String) async throws {
        let deleteWorkspaceParams = DeleteWorkspaceParams(workspaceID: workspaceId)
        do {
            let response = try await request(.deleteWorkspace(params: deleteWorkspaceParams))
            switch response.statusCode {
            case 200: print("워크스페이스 삭제 완료")
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let deleteWorkspaceError = DeleteWorkspaceError(rawValue: errorCode.errorCode) {
                    throw deleteWorkspaceError
                }
            default: break
            }
        } catch {
            throw error
        }
    }
}
