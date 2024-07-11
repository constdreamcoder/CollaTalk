//
//  LoadingView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/11/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
                .padding()
            Text("Loading...")
                .foregroundColor(.white)
        }
        .padding(20)
        .background(Color.black.opacity(0.8))
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
