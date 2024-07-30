//
//  SendChannelChatRequest.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/30/24.
//

import Foundation

struct SendChannelChatRequest: Encodable {
    let content: String?
    let files: [ImageFile]?
}
