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
}

extension ProfileService: BaseService {
    var path: String {
        switch self {
        case .fetchMyProfile:
            return "/users/me"
        case .changeProfileImage:
            return "/users/me/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMyProfile:
            return .get
        case .changeProfileImage:
            return .put
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchMyProfile:
            return .requestPlain
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
        }
    }
}

