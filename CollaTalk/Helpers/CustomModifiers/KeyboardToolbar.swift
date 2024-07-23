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
    
    init(height: CGFloat, @ViewBuilder toolbarView: () -> ToolBarView) {
        self.height = height
        self.toolbarView = toolbarView()
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            GeometryReader { proxy in
                content
                    .frame(width: proxy.size.width, height: proxy.size.height - height)
            }
            
            toolbarView
                .frame(height: height)
        }
    }
}

extension View {
    func keyboardToolbar<ToolbarView>(height: CGFloat, view: @escaping () -> ToolbarView) -> some View where ToolbarView: View {
        modifier(KeyboardToolbar(height: height, toolbarView: view))
    }
}
