//
//  UnreadDMCount.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/26/24.
//

import Foundation

struct UnreadDMCount: Decodable {
    let roomId: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case count
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.roomId = try container.decode(String.self, forKey: .roomId)
        self.count = try container.decode(Int.self, forKey: .count)
    }
}
