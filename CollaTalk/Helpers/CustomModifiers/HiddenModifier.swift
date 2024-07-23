//
//  HiddenModifier.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/23/24.
//

import SwiftUI

struct HiddenModifier: ViewModifier {
    
    let isHidden: Bool
        
    func body(content: Content) -> some View {
        if isHidden {
            content.hidden()
        } else {
            content
        }
    }
}

extension View {
    func hidden(_ isHidden: Bool) -> some View {
        modifier(HiddenModifier(isHidden: isHidden))
    }
}
