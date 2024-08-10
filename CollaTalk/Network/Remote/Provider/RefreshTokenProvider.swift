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
    
    func refreshToken() async throws -> RefreshedToken? {
        return try await performRequest(.refreshToken, errorType: RefreshTokenError.self) { data in
            try decode(data, as: RefreshedToken.self)
        }
    }
}
