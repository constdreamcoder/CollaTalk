//
//  SendDirectMessageRequest.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/25/24.
//

import Foundation

struct SendDirectMessageRequest: Encodable {
    let content: String?
    let files: [ImageFile]?
}
