//
//  ContentView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 6/26/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject private var store: AppStore
    
    @StateObject private var windowProvider = WindowProvider()
    
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
            LoginView(isPresented: $isLoginViewPresented)
        }
        .sheet(isPresented: $isSignUpViewPresented) {
            SignUpView(isPresented: $isSignUpViewPresented)
        }
        .onReceive(Just(store.state.showToast)) { showToast in
            if showToast {
                windowProvider.showToast(message: store.state.errorMessage)
                store.dispatch(.dismissToastMessage)
            }
        }
    }
}

#Preview {
    ContentView()
}
