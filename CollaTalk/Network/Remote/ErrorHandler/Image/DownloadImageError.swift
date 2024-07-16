//
//  DownloadImageError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/16/24.
//

import Foundation

enum DownloadImageError: LocalizedError {
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        }
    }
}
