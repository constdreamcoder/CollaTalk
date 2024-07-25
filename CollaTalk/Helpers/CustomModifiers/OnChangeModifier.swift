//
//  OnChangeModifier.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/25/24.
//

import SwiftUI

struct OnChangeModifier<Value: Equatable>: ViewModifier {
    
    let value: Value
    let action: (Value) -> Void
        
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .onChange(of: value) { _, newValue in
                    print("ios 17이상")
                    action(newValue)
                }
        } else {
            content
                .onChange(of: value, perform: { newValue in
                    print("ios 17이하")
                    action(newValue)
                })
        }
    }
}

extension View {
    func onChange<Value: Equatable>(
        of value: Value,
        action: @escaping (Value) -> Void
    ) -> some View {
        modifier(OnChangeModifier(value: value, action: action))
    }
}
