//
//  ChannelProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/29/24.
//

import Foundation

final class ChannelProvider: BaseProvider<ChannelService> {
    
    static let shared = ChannelProvider()
    
    private override init() {}
    
    func fetchChannelChats(workspaceID: String, channelID: String, cursorDate: String?) async throws -> [ChannelChat]? {
        let fetchChannelParams = FetchChannelChatsParams(workspaceID: workspaceID, channelID: channelID)
        let fetchChannelChatsQuery = FetchChannelChatsQuery(cursorDate: cursorDate)
        return try await performRequest(.fetchChannelChats(params: fetchChannelParams, query: fetchChannelChatsQuery), errorType: FetchChannelChatsError.self) { data in
            return try decode(data, as: [ChannelChat].self)
        }
    }
    
    func sendChannelChat(workspaceID: String, channelID: String, message: String?, files: [ImageFile]?) async throws -> ChannelChat? {
        let sendChannelChatParams = SendChannelChatParams(channelID: channelID, workspaceID: workspaceID)
        let sendChannelChatRequest = SendChannelChatRequest(content: message, files: files)
        return try await performRequest(.sendChannelChat(params: sendChannelChatParams, request: sendChannelChatRequest), errorType: SendChannelChatError.self) { data in
            return try decode(data, as: ChannelChat.self)
        }
    }
    
    func fetchUnreadChannelChats(workspaceID: String, channelID: String, after: String?) async throws -> UnreadChannelChatCount? {
        let fetchUnreadChannelChatsParams = FetchUnreadChannelChatsParams(workspaceID: workspaceID, channelID: channelID)
        let fetchUnreadChannelQuery = FetchUnreadChannelQuery(after: after)
        return try await performRequest(.fetchUnreadChannelChats(params: fetchUnreadChannelChatsParams, query: fetchUnreadChannelQuery), errorType: FetchUnreadChannelChatsError.self) { data in
            return try decode(data, as: UnreadChannelChatCount.self)
        }
    }
    
    func createNewChannel(workspaceID: String, name: String, description: String?) async throws -> Channel? {
        let createNewChannelParams = CreateNewChannelParams(workspaceID: workspaceID)
        let createNewChannelRequest = CreateNewChannelRequest(name: name, description: description, image: nil)
        return try await performRequest(.createNewChannel(params: createNewChannelParams, request: createNewChannelRequest), errorType: CreateNewChannelError.self) { data in
            return try decode(data, as: Channel.self)
        }
    }
    
    func fetchAllChannels(workspaceID: String) async throws -> [Channel]? {
        let fetchAllChannelsParams = FetchAllChannelsParams(workspaceID: workspaceID)
        return try await performRequest(.fetchAllChannels(params: fetchAllChannelsParams), errorType: FetchAllChannelsError.self) { data in
            return try decode(data, as: [Channel].self)
        }
    }
    
    func fetchChannelDetails(workspaceID: String, channelID: String) async throws -> Channel? {
        let fetchChannelDetailsParams = FetchChannelDetailsParams(workspaceID: workspaceID, channelID: channelID)
        return try await performRequest(.fetchChannelDetails(params: fetchChannelDetailsParams), errorType: FetchChannelDetailsError.self) { data in
            return try decode(data, as: Channel.self)
        }
    }
    
    func editChannelDetails(workspaceID: String, channelID: String, name: String, description: String?) async throws -> Channel? {
        let editChannelDetailsParams = EditChannelDetailsParams(workspaceID: workspaceID, channelID: channelID)
        let editChannelDetailsRequest = EditChannelDetailsRequest(name: name, description: description, image: nil)
        return try await performRequest(.editChannelDetails(params: editChannelDetailsParams, request: editChannelDetailsRequest), errorType: EditChannelDetailsError.self) { data in
            return try decode(data, as: Channel.self)
        }
    }
    
    func fetchChannelMembers(workspaceID: String, channelID: String) async throws -> [WorkspaceMember]? {
        let fetchChannelMembersParams = FetchChannelMembersParams(workspaceID: workspaceID, channelID: channelID)
        return try await performRequest(.fetchChannelMembers(params: fetchChannelMembersParams), errorType: FetchChannelMembersError.self) { data in
            return try decode(data, as: [WorkspaceMember].self)
        }
    }
    
    func changeChannelOwnership(workspaceID: String, channelID: String, ownerId: String) async throws -> Channel? {
        let changeChannelOwnershipParams = ChangeChannelOwnershipParams(workspaceID: workspaceID, channelID: channelID)
        let changeChannelOwnershipRequest = ChangeChannelOwnershipRequest(owner_id: ownerId)
        return try await performRequest(.changeChannelOwnership(params: changeChannelOwnershipParams, request: changeChannelOwnershipRequest), errorType: ChangeChannelOwnershipError.self) { data in
            return try decode(data, as: Channel.self)
        }
    }
    
    func leaveChannel(workspaceID: String, channelID: String) async throws -> [Channel]? {
        let leaveChannelParams = LeaveChannelParams(workspaceID: workspaceID, channelID: channelID)
        return try await performRequest(.leaveChannel(params: leaveChannelParams), errorType: LeaveChannelError.self) { data in
            return try decode(data, as: [Channel].self)
        }
    }
    
    func deleteChannel(workspaceID: String, channelID: String) async throws -> Bool? {
        let deleteChannelParams = DeleteChannelParams(workspaceID: workspaceID, channelID: channelID)
        return try await performRequest(.deleteChannel(params: deleteChannelParams), errorType: DeleteChannelError.self) { data in
            return true
        }
    }
}
