//
//  UserProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation

final class UserProvider: BaseProvider<UserService> {
    
    static let shared = UserProvider()
    
    private override init() {}
    
    func login(email: String, password: String) async throws -> UserInfo? {
        do {
            let loginRequest = LoginRequest(email: email, password: password)
            let response = try await request(.login(request: loginRequest))
            switch response.statusCode {
            case 200:
                let userInfo = try decode(response.data, as: UserInfo.self)
                return userInfo
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                }
            default:
                break
            }
        } catch {
            throw error
        }
        
        return nil
    }
}
