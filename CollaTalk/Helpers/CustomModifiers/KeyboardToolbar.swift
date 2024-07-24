//
//  KeyboardToolbar.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/23/24.
//

import SwiftUI

struct KeyboardToolbar<ToolBarView: View>: ViewModifier {
    
    private let height: CGFloat
    private let toolbarView: ToolBarView
    private let toolbarViewPadding: CGFloat = 10
    
    init(height: CGFloat, @ViewBuilder toolbarView: () -> ToolBarView) {
        self.height = height
        self.toolbarView = toolbarView()
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            GeometryReader { proxy in
                content
                    .frame(width: proxy.size.width, height: proxy.size.height - height - toolbarViewPadding)
            }
            
            toolbarView
                .frame(height: height)
                .padding(.vertical, toolbarViewPadding) // 키보드와 간격 추가
        }
    }
}

extension View {
    func keyboardToolbar<ToolbarView>(height: CGFloat, view: @escaping () -> ToolbarView) -> some View where ToolbarView: View {
        modifier(KeyboardToolbar(height: height, toolbarView: view))
    }
}
