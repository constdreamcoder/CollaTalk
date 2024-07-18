//
//  EditWorkspaceRequest.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/18/24.
//

import Foundation

struct EditWorkspaceRequest: Encodable {
    let name: String
    let description: String?
    let image: ImageFile
}
