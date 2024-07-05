//
//  ContentView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 6/26/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isBottomSheetPresented: Bool = false
    @State private var isLoginViewPresented: Bool = false
    @State private var isSignUpViewPresented: Bool = false
    
    var body: some View {
        ZStack {
            OnboardingView(isBottomSheetPresented: $isBottomSheetPresented)
            
            AuthView(
                isBottomSheetPresented: $isBottomSheetPresented,
                isLoginViewPresented: $isLoginViewPresented, 
                isSignUpViewPresented: $isSignUpViewPresented
            )
        }
        .animation(.interactiveSpring, value: isBottomSheetPresented)
        .sheet(isPresented: $isLoginViewPresented) {

        }
        .sheet(isPresented: $isSignUpViewPresented) {

        }
    }
}

#Preview {
    ContentView()
}
