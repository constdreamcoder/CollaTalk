//
//  SocketIOManager.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/27/24.
//

import Foundation
import SocketIO
import Combine

final class SocketIOManager {
    
    static let shared = SocketIOManager()
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    let receivedChatDataSubject = PassthroughSubject<DirectMessage, Never>()
    
    private init() {
        guard let url = URL(string: APIKeys.baseURL) else { return }
        manager = SocketManager(socketURL: url, config: [.log(true), .compress])
    }
    
    func setupSocketEventListeners(_ roomId: String) {
        guard let manager else { return }
        socket = manager.socket(forNamespace: "/ws-dm-\(roomId)")
        guard let socket else { return }
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        socket.on("chat") { [weak self] dataArray, ack in
            guard let self else { return }
            print("chat received")
            
            if let data = dataArray.first {
                
                do {
                    let result = try JSONSerialization.data(withJSONObject: data)
                    let decodedData = try JSONDecoder().decode(DirectMessage.self, from: result)
                    receivedChatDataSubject.send(decodedData)
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
}
