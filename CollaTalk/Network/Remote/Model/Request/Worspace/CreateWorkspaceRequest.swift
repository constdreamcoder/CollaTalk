//
//  CreateWorkspaceRequest.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/15/24.
//

import Foundation

enum MultiPartFormKey {
    static let name = "name"
    static let description = "description"
    static let image = "image"
}

struct CreateWorkspaceRequest: Encodable {
    let name: String
    let description: String?
    let image: ImageFile
}

struct ImageFile: Encodable {
    let imageData: Data
    let name: String
    let mimeType: MemeType
    
    enum MemeType: String, Encodable {
        case png = "image/png"
        case jpeg = "image/jpeg"
        case jpg = "image/jpg"
    }
}

