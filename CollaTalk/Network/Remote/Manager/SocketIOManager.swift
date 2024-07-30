//
//  SocketIOManager.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/27/24.
//

import Foundation
import SocketIO
import Combine

final class SocketIOManager: ObservableObject {
    static let shared = SocketIOManager()
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    @Published var receivedDMSubject = PassthroughSubject<DirectMessage, Never>()
    @Published var receivedChannelChatSubject = PassthroughSubject<ChannelChat, Never>()
    
    private init() {
        guard let url = URL(string: APIKeys.baseURL) else { return }
        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
    }
    
    func setupSocketEventListeners(_ socketType: SocketType) {
        guard let manager else { return }
        socket = manager.socket(forNamespace: socketType.namespace)
        guard let socket else { return }
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        socket.on(socketType.eventName) { [weak self] dataArray, ack in
            guard let self else { return }
            print("\(socketType.eventName) received")
            
            if let data = dataArray.first {
                
                do {
                    let result = try JSONSerialization.data(withJSONObject: data)
                    switch socketType {
                    case .dm:
                        let decodedDMData = try JSONDecoder().decode(DirectMessage.self, from: result)
                        receivedDMSubject.send(decodedDMData)
                    case .channel:
                        let decodedChannelChatData = try JSONDecoder().decode(ChannelChat.self, from: result)
                        receivedChannelChatSubject.send(decodedChannelChatData)
                    }
                } catch {
                    print("Chatting Recevied Parsing Error", error.localizedDescription)
                }
            }
        }
    }
    
    func establishConnection() {
        socket?.connect()
    }
    
    func leaveConnection() {
        socket?.disconnect()
    }
    
    func removeAllEventHandlers() {
        print("Clear up all handlers.")
        print("socket handler count", socket?.handlers.count)
        socket?.removeAllHandlers()
    }
    
    enum SocketType {
        case dm(roomId: String)
        case channel(channelId: String)
        
        var namespace: String {
            switch self {
            case .dm(let roomId):
                return "/ws-dm-\(roomId)"
            case .channel(let channelId):
                return "/ws-channel-\(channelId)"
            }
        }
        
        var eventName: String {
            switch self {
            case .dm:
                return "dm"
            case .channel:
                return "channel"
            }
        }
    }
}
