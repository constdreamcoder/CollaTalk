//
//  DownloadImageError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/16/24.
//

import Foundation

enum DownloadImageError: LocalizedError {
    case invalidURL
    case duplicatedData
    case unstableNetworkConnection
    case imageCapacityLimit
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .duplicatedData:
            return "중복된 이미지가 존재합니다."
        case .unstableNetworkConnection:
            return "네트워크가 불안정합니다."
        case .imageCapacityLimit:
            return "1MB이하의 이미지만 업로드 가능합니다."
        }
    }
}
