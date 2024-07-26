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
    
    func createOrFetchChatRoom(workspaceID: String, opponentID: String) async throws -> DMRoom? {
        do {
            let createOrFetchChatRoomParams = CreateOrFetchChatRoomParams(workspaceID: workspaceID)
            let createOrFetchChatRoomRequest = CreateOrFetchChatRoomRequest(opponent_id: opponentID)
            let response = try await request(.createOrFetchChatRoom(params: createOrFetchChatRoomParams, request: createOrFetchChatRoomRequest))
            switch response.statusCode {
            case 200:
                // 새로 생성된 채팅방 혹은 이미 생성되어 있던 채팅방
                let chatRoom = try decode(response.data, as: DMRoom.self)
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
    
    func sendDirectMessage( workspaceID: String, roomID: String, message: String?, files: [ImageFile]?) async throws -> DirectMessage? {
        do {
            let sendDirectMessageParams = SendDirectMessageParams(workspaceID: workspaceID, roomID: roomID)
            let sendDirectMessageRequest = SendDirectMessageRequest(content: message, files: files)
            let response = try await request(.sendDirectMessage(params: sendDirectMessageParams, request: sendDirectMessageRequest))
            switch response.statusCode {
            case 200:
                let newMessage = try decode(response.data, as: DirectMessage.self)
                return newMessage
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let sendDirectMessageError = SendDirectMessageError(rawValue: errorCode.errorCode) {
                    throw sendDirectMessageError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
}

