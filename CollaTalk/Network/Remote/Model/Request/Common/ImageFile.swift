//
//  ImageFile.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/18/24.
//

import Foundation

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
