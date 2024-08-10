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
        let loginRequest = LoginRequest(email: email, password: password)
        return try await performRequest(.login(request: loginRequest), errorType: CommonError.self) { data in
            return try decode(data, as: UserInfo.self)
        }
    }
    
    func loginWithAppleID(idToken: String, nickname: String?) async throws -> UserInfo? {
        let loginWithAppleIDRequest = LoginWithAppleIDRequest(idToken: idToken, nickname: nickname, deviceToken: nil)
        return try await performRequest(.loginWithAppleID(request: loginWithAppleIDRequest), errorType: LoginWithAppleIDError.self) { data in
            return try decode(data, as: UserInfo.self)
        }
    }
    
    func loginWithKakao(oauthToken: String) async throws -> UserInfo? {
        let loginWithKakaoRequest = LoginWithKakaoRequest(oauthToken: oauthToken, deviceToken: nil)
        return try await performRequest(.loginWithKakao(request: loginWithKakaoRequest), errorType: LoginWithKakaoError.self) { data in
            return try decode(data, as: UserInfo.self)
        }
    }
    
    func validate(email: String) async throws -> Bool? {
        if email == "" { return true }
        let emailValidationRequest = EmailValidationRequest(email: email)
        return try await performRequest(.validateEmail(request: emailValidationRequest), errorType: JoinError.self) { data in
            return true
        }
    }
    
    func join(email: String, password: String, nickname: String, phone: String?) async throws -> UserInfo? {
        let joinRequest = JoinRequest(email: email, password: password, nickname: nickname, phone: phone, deviceToken: APIKeys.sampleDeviceToken)
        return try await performRequest(.join(request: joinRequest), errorType: JoinError.self) { data in
            return try decode(data, as: UserInfo.self)
        }
    }
    
    func logout() async throws -> Bool? {
        return try await performRequest(.logout, errorType: CommonError.self) { data in
            return true
        }
    }
    
    func fetchOtherProfile(userId: String) async throws -> OtherProfile? {
        let fetchOtherProfileParams = FetchOtherProfileParams(userID: userId)
        return try await performRequest(.fetchOtherProfile(params: fetchOtherProfileParams), errorType: CommonError.self) { data in
            return try decode(data, as: OtherProfile.self)
        }
    }
}
