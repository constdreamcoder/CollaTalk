//
//  CustomButton.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/5/24.
//

import SwiftUI

struct CustomButton<Content>: View where Content: View {
    
    private let action: () -> Void
    private let label: Content
    
    init(action: @escaping () -> Void, @ViewBuilder label: () -> Content) {
        self.action = action
        self.label = label()
    }
    
    var body: some View {
        Button(action: action, label: {
            label
                .foregroundStyle(.brandWhite)
                .font(.title2)
                .frame(maxWidth: .infinity, idealHeight: 44, maxHeight: 44)
        })
    }
}

#Preview {
    CustomButton(action: {print("시작!")}, label: {
        Text("시작하기")
    })
}
