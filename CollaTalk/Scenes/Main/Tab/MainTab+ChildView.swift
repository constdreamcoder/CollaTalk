//
//  MainTab+ChildView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/13/24.
//

import SwiftUI

extension MainTab {
    @ViewBuilder
    var view: some View {
        switch self {
        case .home: HomeDefaultView()
        case .dm: placeholderView
        case .search: placeholderView
        case .setting: placeholderView
        }
    }
    
    private var placeholderView: some View {
        Text("빈 화면입니다.\n검색으로 이동 해 주세요.")
            .multilineTextAlignment(.center)
    }
}
