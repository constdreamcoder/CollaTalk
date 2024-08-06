//
//  LoginWithAppleIDRequest.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/6/24.
//

import Foundation

struct LoginWithAppleIDRequest: Encodable {
    let idToken: String
    let nickname: String?
    let deviceToken: String?
}
