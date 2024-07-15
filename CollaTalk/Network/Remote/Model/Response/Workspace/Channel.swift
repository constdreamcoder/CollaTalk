//
//  Channel.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/15/24.
//

import Foundation

struct Channel: Decodable {
    let channel_id: String
    let name: String
    let description: String?
    let coverImage: String?
    let owner_id: String
    let createdAt: String
}
