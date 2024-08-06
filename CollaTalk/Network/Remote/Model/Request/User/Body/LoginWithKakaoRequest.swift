//
//  LoginWithKakaoRequest.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/6/24.
//

import Foundation

struct LoginWithKakaoRequest: Encodable {
    let oauthToken: String
    let deviceToken: String?
}
