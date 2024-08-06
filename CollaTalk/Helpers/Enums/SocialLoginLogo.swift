//
//  SocialLoginLogo.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/6/24.
//

import Foundation

enum SocialLoginLogo: String, Encodable {
    case apple = "apple"
    case kakao = "kakao"
    case none = "none"
    
    var image: String? {
        switch self {
        case .apple:
            return "appleIDLogin"
        case .kakao:
            return "kakaoLogin"
        case .none:
            return ""
        }
    }
}
