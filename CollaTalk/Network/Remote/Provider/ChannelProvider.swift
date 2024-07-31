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
        do {
            let fetchChannelParams = FetchChannelChatsParams(workspaceID: workspaceID, channelID: channelID)
            let fetchChannelChatsQuery = FetchChannelChatsQuery(cursorDate: cursorDate)
            let response = try await request(.fetchChannelChats(params: fetchChannelParams, query: fetchChannelChatsQuery))
            switch response.statusCode {
            case 200:
                // 새로 생성된 채팅방 혹은 이미 생성되어 있던 채팅방
                let channelChats = try decode(response.data, as: [ChannelChat].self)
                return channelChats
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let fetchChannelChatsError = FetchChannelChatsError(rawValue: errorCode.errorCode) {
                    throw fetchChannelChatsError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func sendChannelChat(workspaceID: String, channelID: String, message: String?, files: [ImageFile]?) async throws -> ChannelChat? {
        do {
            let sendChannelChatParams = SendChannelChatParams(channelID: channelID, workspaceID: workspaceID)
            let sendChannelChatRequest = SendChannelChatRequest(content: message, files: files)
            let response = try await request(.sendChannelChat(params: sendChannelChatParams, request: sendChannelChatRequest))
            switch response.statusCode {
            case 200:
                let newChannelChat = try decode(response.data, as: ChannelChat.self)
                return newChannelChat
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let sendChannelChatError = SendChannelChatError(rawValue: errorCode.errorCode) {
                    throw sendChannelChatError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func fetchUnreadChannelChats(workspaceID: String, channelID: String, after: String?) async throws -> UnreadChannelChatCount? {
        do {
            let fetchUnreadChannelChatsParams = FetchUnreadChannelChatsParams(workspaceID: workspaceID, channelID: channelID)
            let fetchUnreadChannelQuery = FetchUnreadChannelQuery(after: after)
            let response = try await request(.fetchUnreadChannelChats(params: fetchUnreadChannelChatsParams, query: fetchUnreadChannelQuery))
            switch response.statusCode {
            case 200:
                let unreadChannelChatCount = try decode(response.data, as: UnreadChannelChatCount.self)
                return unreadChannelChatCount
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let fetchUnreadChannelChatsError = FetchUnreadChannelChatsError(rawValue: errorCode.errorCode) {
                    throw fetchUnreadChannelChatsError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func createNewChannel(workspaceID: String, name: String, description: String?) async throws -> Channel? {
        do {
            let createNewChannelParams = CreateNewChannelParams(workspaceID: workspaceID)
            let createNewChannelRequest = CreateNewChannelRequest(name: name, description: description, image: nil)
            let response = try await request(.createNewChannel(params: createNewChannelParams, request: createNewChannelRequest))
            switch response.statusCode {
            case 200:
                let newChannel = try decode(response.data, as: Channel.self)
                return newChannel
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let createNewChannelError = CreateNewChannelError(rawValue: errorCode.errorCode) {
                    throw createNewChannelError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func fetchAllChannels(workspaceID: String) async throws -> [Channel]? {
        do {
            let fetchAllChannelsParams = FetchAllChannelsParams(workspaceID: workspaceID)
            let response = try await request(.fetchAllChannels(params: fetchAllChannelsParams))
            switch response.statusCode {
            case 200:
                let allChannels = try decode(response.data, as: [Channel].self)
                return allChannels
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let createNewChannelError = FetchAllChannelsError(rawValue: errorCode.errorCode) {
                    throw createNewChannelError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func fetchChannelDetails(workspaceID: String, channelID: String) async throws -> Channel? {
        do {
            let fetchChannelDetailsParams = FetchChannelDetailsParams(workspaceID: workspaceID, channelID: channelID)
            let response = try await request(.fetchChannelDetails(params: fetchChannelDetailsParams))
            switch response.statusCode {
            case 200:
                let allChannels = try decode(response.data, as: Channel.self)
                return allChannels
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let fetchChannelDetailsError = FetchChannelDetailsError(rawValue: errorCode.errorCode) {
                    throw fetchChannelDetailsError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func editChannelDetails(workspaceID: String, channelID: String, name: String, description: String?) async throws -> Channel? {
        do {
            let editChannelDetailsParams = EditChannelDetailsParams(workspaceID: workspaceID, channelID: channelID)
            let editChannelDetailsRequest = EditChannelDetailsRequest(name: name, description: description, image: nil)
            let response = try await request(.editChannelDetails(params: editChannelDetailsParams, request: editChannelDetailsRequest))
            switch response.statusCode {
            case 200:
                let updatedChannel = try decode(response.data, as: Channel.self)
                return updatedChannel
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let editChannelDetailsError = EditChannelDetailsError(rawValue: errorCode.errorCode) {
                    throw editChannelDetailsError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func fetchChannelMembers(workspaceID: String, channelID: String) async throws -> [WorkspaceMember]? {
        do {
            let fetchChannelMembersParams = FetchChannelMembersParams(workspaceID: workspaceID, channelID: channelID)
            let response = try await request(.fetchChannelMembers(params: fetchChannelMembersParams))
            switch response.statusCode {
            case 200:
                let updatedChannel = try decode(response.data, as: [WorkspaceMember].self)
                return updatedChannel
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let fetchChannelMembersError = FetchChannelMembersError(rawValue: errorCode.errorCode) {
                    throw fetchChannelMembersError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func changeChannelOwnership(workspaceID: String, channelID: String, ownerId: String) async throws -> Channel? {
        do {
            let changeChannelOwnershipParams = ChangeChannelOwnershipParams(workspaceID: workspaceID, channelID: channelID)
            let changeChannelOwnershipRequest = ChangeChannelOwnershipRequest(owner_id: ownerId)
            let response = try await request(.changeChannelOwnership(params: changeChannelOwnershipParams, request: changeChannelOwnershipRequest))
            switch response.statusCode {
            case 200:
                let updatedChannel = try decode(response.data, as: Channel.self)
                return updatedChannel
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let changeChannelOwnershipError = ChangeChannelOwnershipError(rawValue: errorCode.errorCode) {
                    throw changeChannelOwnershipError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
}
