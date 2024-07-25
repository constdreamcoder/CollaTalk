//
//  ChatRoom.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/25/24.
//

import Foundation

struct ChatRoom: Decodable {
    let room_id: String
    let createdAt: String
    let user: WorkspaceMember
}
