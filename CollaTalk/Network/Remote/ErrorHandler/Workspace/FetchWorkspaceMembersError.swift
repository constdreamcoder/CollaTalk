//
//  FetchWorkspaceMembersError.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/20/24.
//

import Foundation

enum FetchWorkspaceMembersError: String, LocalizedError {
    case noData = "E13"
  
    var errorDescription: String? {
        switch self {
        case .noData:
            return "존재하지 않는 데이터입니다."
        }
    }
}
