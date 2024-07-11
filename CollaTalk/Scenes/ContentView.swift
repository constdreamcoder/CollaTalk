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
    @StateObject private var navigationRouter = NavigationRouter()
    
    @State private var isBottomSheetPresented: Bool = false
    @State private var isLoginViewPresented: Bool = false
    @State private var isSignUpViewPresented: Bool = false
    @State private var isCreateWorkspaceViewPresented: Bool = false
    
    var body: some View {
        NavigationStack(path: $navigationRouter.route) {
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
            .sheet(isPresented: $isCreateWorkspaceViewPresented) {
                CreateWorkspaceView()
            }
            .navigationDestination(for: PathType.self) { path in
                switch path {
                case .homeView:
                    WorspaceInitView()
                }
            }
        }
        .environmentObject(navigationRouter)
        .onReceive(Just(store.state.showToast)) { showToast in
            if showToast {
                windowProvider.showToast(message: store.state.toastMessage)
                store.dispatch(.dismissToastMessage)
            }
        }
    }
}

#Preview {
    ContentView()
}
