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
    
    func changeProfileImage(image: ImageFile) async throws -> ChangedMyProfile? {
        do {
            let changeProfileImageRequest = ChangeProfileImageRequest(image: image)
            let response = try await request(.changeProfileImage(request: changeProfileImageRequest))
            switch response.statusCode {
            case 200:
                let changnedMyProfile = try decode(response.data, as: ChangedMyProfile.self)
                return changnedMyProfile
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let changeProfileImageError = ChangeProfileImageError(rawValue: errorCode.errorCode) {
                    throw changeProfileImageError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    func changeProfileInfo(nickname: String? = "" , phone: String? = "") async throws -> ChangedMyProfile? {
        do {
            let changeProfileInfoRequest = ChangeProfileInfoRequest(nickname: nickname, phone: phone)
            let response = try await request(.changeProfileInfo(request: changeProfileInfoRequest))
            switch response.statusCode {
            case 200:
                let changnedMyProfile = try decode(response.data, as: ChangedMyProfile.self)
                return changnedMyProfile
            case 400...500:
                let errorCode = try decode(response.data, as: ErrorCode.self)
                if let commonError = CommonError(rawValue: errorCode.errorCode) {
                    throw commonError
                } else if let changeProfileInfoError = ChangeProfileInfoError(rawValue: errorCode.errorCode) {
                    throw changeProfileInfoError
                }
            default: break
            }
        } catch {
            throw error
        }
        
        return nil
    }
}



