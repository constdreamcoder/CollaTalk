//
//  CreateWorkspaceRequest.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/15/24.
//

import Foundation

struct CreateWorkspaceRequest: Encodable {
    let name: String
    let description: String?
    let image: ImageFile
}
