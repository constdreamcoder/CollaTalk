//
//  JoinRequest.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/10/24.
//

import Foundation

struct JoinRequest: Encodable {
    let email: String
    let password: String
    let nickname: String
    let phone: String?
    let deviceToken: String?
}
