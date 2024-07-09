//
//  ToastView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/9/24.
//

import SwiftUI

struct ToastView: View {
    var message: String
    
    var body: some View {
        Text(message)
            .font(.body)
            .foregroundStyle(.white)
            .padding()
            .background(.brandGreen)
            .cornerRadius(8)
            .shadow(radius: 10)
    }
}

#Preview {
    ToastView(message: "자랑스럽다")
}
