//
//  ImageService.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/16/24.
//
import Foundation
import Moya

enum ImageService {
    case downloadImage(path: String)
}

extension ImageService: BaseService {
    var path: String {
        switch self {
        case .downloadImage(let urlString):
            return urlString
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .downloadImage:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .downloadImage:
            return .requestPlain
        }
    }
}
