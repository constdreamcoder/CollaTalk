//
//  UnreadChannelChatCount.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/30/24.
//

import Foundation

struct UnreadChannelChatCount: Decodable {
    let channelId: String
    let name: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case name
        case count
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.channelId = try container.decode(String.self, forKey: .channelId)
        self.name = try container.decode(String.self, forKey: .name)
        self.count = try container.decode(Int.self, forKey: .count)
    }
}
