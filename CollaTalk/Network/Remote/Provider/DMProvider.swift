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
        let createOrFetchChatRoomParams = CreateOrFetchChatRoomParams(workspaceID: workspaceID)
        let createOrFetchChatRoomRequest = CreateOrFetchChatRoomRequest(opponent_id: opponentID)
        return try await performRequest(.createOrFetchChatRoom(params: createOrFetchChatRoomParams, request: createOrFetchChatRoomRequest), errorType: CreateOrFetchChatRoomError.self) { data in
            return try decode(data, as: DMRoom.self)
        }
    }
    
    func sendDirectMessage(workspaceID: String, roomID: String, message: String?, files: [ImageFile]?) async throws -> DirectMessage? {
        let sendDirectMessageParams = SendDirectMessageParams(workspaceID: workspaceID, roomID: roomID)
        let sendDirectMessageRequest = SendDirectMessageRequest(content: message, files: files)
        return try await performRequest(.sendDirectMessage(params: sendDirectMessageParams, request: sendDirectMessageRequest), errorType: SendDirectMessageError.self) { data in
            return try decode(data, as: DirectMessage.self)
        }
    }
    
    func fetchDMHistory(workspaceID: String, roomID: String, cursorDate: String?) async throws -> [DirectMessage]? {
        let fetchDMHistoryParams = FetchDMHistoryParams(workspaceID: workspaceID, roomID: roomID)
        let fetchDMHistoryQuery = FetchDMHistoryQuery(cursorDate: cursorDate)
        return try await performRequest(.fetchDMHistory(params: fetchDMHistoryParams, query: fetchDMHistoryQuery), errorType: FetchDMHistoryError.self) { data in
            return try decode(data, as: [DirectMessage].self)
        }
    }
    
    func fetchUnreadDMCount(workspaceID: String, roomID: String, after: String?) async throws -> UnreadDMCount? {
        let fetchUnreadDMCountParams = FetchUnreadDMCountParams(workspaceID: workspaceID, roomID: roomID)
        let fetchUnreadDMCountQuery = FetchUnreadDMCountQuery(after: after)
        return try await performRequest(.fetchUnreadDMCount(params: fetchUnreadDMCountParams, query: fetchUnreadDMCountQuery), errorType: FetchUnreadDMCountError.self) { data in
            return try decode(data, as: UnreadDMCount.self)
        }
    }
}

