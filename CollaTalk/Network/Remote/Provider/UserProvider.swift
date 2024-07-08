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
    
    func login(email: String, password: String) async -> UserInfo? {
        do {
            let loginRequest = LoginRequest(email: email, password: password)
            let response = try await request(.login(request: loginRequest))
            switch response.statusCode {
            case 200:
                let userInfo = try decode(response.data, as: UserInfo.self)
                return userInfo
            case 400...500:
                print("서버 오류 발생!")
            default:
                break
            }
        } catch {
            print("login error", error)
        }
        
        return nil
    }
}
