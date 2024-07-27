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
        
        socket.on("dm") { [weak self] dataArray, ack in
            guard let self else { return }
            print("dm received")
            
            if let data = dataArray.first {
                
                do {
                    let result = try JSONSerialization.data(withJSONObject: data)
                    let decodedDMData = try JSONDecoder().decode(DirectMessage.self, from: result)
                    receivedDMSubject.send(decodedDMData)
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
