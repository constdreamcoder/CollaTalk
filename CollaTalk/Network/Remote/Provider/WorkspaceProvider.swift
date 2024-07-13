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
    
   
}
