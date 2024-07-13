//
//  HomeContentType.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import Foundation

enum HomeContentType: CaseIterable {
    case channel
    case directMessage
    
    var title: String {
        switch self {
        case .channel:
            return "채널"
        case .directMessage:
            return "다이렉트 메시지"
        }
    }
    
    enum AddType: String {
        case channel = "채널 추가"
        case directMessage = "새 메시지 시작"
        case teamMember = "팀원 추가"
    }
}
