//
//  ProfileService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/3/24.
//

import Foundation
import Moya

enum ProfileService {
    case fetchMyProfile
    case changeProfileImage(request: ChangeProfileImageRequest)
    case changeProfileInfo(request: ChangeProfileInfoRequest)
}

extension ProfileService: BaseService {
    var path: String {
        switch self {
        case .fetchMyProfile, .changeProfileInfo:
            return "/users/me"
        case .changeProfileImage:
            return "/users/me/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMyProfile:
            return .get
        case .changeProfileImage, .changeProfileInfo:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .changeProfileInfo(let request):
            return .requestJSONEncodable(request)
        case .changeProfileImage(let request):
            let imageFile = request.image
            let imageFileMultipart = [
                MultipartFormData(
                    provider: .data(imageFile.imageData),
                    name: MultiPartFormKey.image,
                    fileName: imageFile.name,
                    mimeType: imageFile.mimeType.rawValue
                )
            ]
            return .uploadMultipart(imageFileMultipart)
        case .fetchMyProfile:
            return .requestPlain
        }
    }
}

