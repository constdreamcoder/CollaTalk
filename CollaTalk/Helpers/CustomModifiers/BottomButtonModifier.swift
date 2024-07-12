//
//  BottomButtonModifier.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct BottomButtonModifier: ViewModifier {
    
    let color: Color
        
    func body(content: Content) -> some View {
        content
            .background(color)
            .cornerRadius(8, corners: .allCorners)
            .padding(.horizontal, 24)
    }
}

extension View {
    func bottomButtonShape(_ color: Color) -> some View {
        modifier(BottomButtonModifier(color: color))
    }
}
