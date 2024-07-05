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
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 16)
    }
}

extension View {
    func bottomButtonShape(_ color: Color) -> some View {
        modifier(BottomButtonModifier(color: color))
    }
}
