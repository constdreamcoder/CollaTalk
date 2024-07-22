//
//  MainTab.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/13/24.
//

import SwiftUI

enum MainTab: Int, CaseIterable {
    case home
    case dm
    case search
    case setting
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .dm: return "DM"
        case .search: return "검색"
        case .setting: return "설정"
        }
    }
    
    var imageName: ImageResource {
        switch self {
        case .home: return .homeTabIcon
        case .dm: return .dmTabIcon
        case .search: return .searchTabIcon
        case .setting: return .settingTabIcon
        }
    }
}

/// ChildView
extension MainTab {
    @ViewBuilder
    var view: some View {
        switch self {
        case .home: HomeDefaultView()
        case .dm: DMEmptyView()
        case .search: placeholderView
        case .setting: placeholderView
        }
    }
    
    private var placeholderView: some View {
        Text("빈 화면입니다.\n검색으로 이동 해 주세요.")
            .multilineTextAlignment(.center)
    }
}
