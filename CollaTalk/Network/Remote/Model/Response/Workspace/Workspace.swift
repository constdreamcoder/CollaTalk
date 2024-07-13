//
//  Workspace.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import Foundation

struct Workspace: Decodable {
    let workspaceId: String
    let name: String
    let description: String?
    let coverImage: String
    let ownerId: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case workspaceId = "workspace_id"
        case name
        case description
        case coverImage
        case ownerId = "owner_id"
        case createdAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.workspaceId = try container.decode(String.self, forKey: .workspaceId)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.coverImage = try container.decode(String.self, forKey: .coverImage)
        self.ownerId = try container.decode(String.self, forKey: .ownerId)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}
