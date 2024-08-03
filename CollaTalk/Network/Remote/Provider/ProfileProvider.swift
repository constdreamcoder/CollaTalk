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
            let response = try await request(.fetchMyProfile)
            switch response.statusCode {
            case 200:
                let myProfile = try decode(response.data, as: MyProfile.self)
                return myProfile
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
}



