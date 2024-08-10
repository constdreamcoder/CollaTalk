//
//  RefreshTokenProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/10/24.
//

import Foundation

final class RefreshTokenProvider: BaseProvider<RefreshTokenService> {
    
    static let shared = RefreshTokenProvider()
    
    private override init() {}
    
    func refreshToken() async throws {
        let refreshedToken = try await performRequest(.refreshToken, errorType: RefreshTokenError.self) { data in
            return try decode(data, as: RefreshedToken.self)
        }
        guard let refreshedToken else { return }
        guard var userInfo = UserDefaultsManager.getObject(forKey: .userInfo, as: UserInfo.self) else { return }
        userInfo.token.accessToken = refreshedToken.accessToken
        UserDefaultsManager.setObject(userInfo, forKey: .userInfo)
    }
}
