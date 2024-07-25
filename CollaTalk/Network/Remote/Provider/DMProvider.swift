//
//  DMProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/25/24.
//

import Foundation

final class DMProvider: BaseProvider<DMService> {
    
    static let shared = DMProvider()
    
    private override init() {}
    
    func createOrFetchChatRoom(workspaceID: String, opponentID: String) async throws -> ChatRoom? {
        do {
            let createOrFetchChatRoomParams = CreateOrFetchChatRoomParams(workspaceID: workspaceID)
            let createOrFetchChatRoomRequest = CreateOrFetchChatRoomRequest(opponent_id: opponentID)
            let response = try await request(.createOrFetchChatRoom(params: createOrFetchChatRoomParams, request: createOrFetchChatRoomRequest))
            switch response.statusCode {
            case 200:
                // 새로 생성된 채팅방 혹은 이미 생성되어 있던 채팅방
                let chatRoom = try decode(response.data, as: ChatRoom.self)
                return chatRoom
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let createOrFetchChatRoomError = CreateOrFetchChatRoomError(rawValue: errorCode.errorCode) {
                    throw createOrFetchChatRoomError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
}

