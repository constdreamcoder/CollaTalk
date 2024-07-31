//
//  FetchChannelDetailsError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/31/24.
//

import Foundation

enum FetchChannelDetailsError: String, LocalizedError {
    case noData = "E13"
  
    var errorDescription: String? {
        switch self {
        case .noData:
            return "존재하지 않는 데이터입니다."
        }
    }
}

