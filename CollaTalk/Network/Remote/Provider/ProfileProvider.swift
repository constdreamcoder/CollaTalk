//
//  ProfileProvider.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/3/24.
//

import Foundation

final class ProfileProvider: BaseProvider<ProfileService> {
    
    static let shared = ProfileProvider()
    
    private override init() {}
    
    func fetchMyProfile() async throws -> MyProfile? {
        do {
            return try await performRequest(.fetchMyProfile, errorType: CommonError.self) { data in
                return try decode(data, as: MyProfile.self)
            }
        } catch {
            throw error
        }
    }
    
    func changeProfileImage(image: ImageFile) async throws -> ChangedMyProfile? {
        let changeProfileImageRequest = ChangeProfileImageRequest(image: image)
        return try await performRequest(.changeProfileImage(request: changeProfileImageRequest), errorType: ChangeProfileImageError.self) { data in
            return try decode(data, as: ChangedMyProfile.self)
        }
    }
    
    func changeProfileInfo(nickname: String?, phone: String?) async throws -> ChangedMyProfile? {
        let changeProfileInfoRequest = ChangeProfileInfoRequest(nickname: nickname, phone: phone)
        return try await performRequest(.changeProfileInfo(request: changeProfileInfoRequest), errorType: ChangeProfileInfoError.self) { data in
            return try decode(data, as: ChangedMyProfile.self)
        }
    }
}
