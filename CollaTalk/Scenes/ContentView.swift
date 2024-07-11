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
    
    
    var body: some View {
        NavigationStack(path: $navigationRouter.route) {
            ZStack {
                OnboardingView()
                
                AuthView()
            }
            .animation(.interactiveSpring, value: store.state.navigationState.isBottomSheetPresented)
            .sheet(
                isPresented: Binding(
                    get: { store.state.navigationState.isLoginViewPresented},
                    set: { store.dispatch(.navigationAction(.presentLoginView(present: $0)))
                    }
                )
            ) {
                LoginView()
            }
            .sheet(
                isPresented: Binding(
                    get: { store.state.navigationState.isSignUpViewPresented },
                    set: { store.dispatch(.navigationAction(.presentSignUpView(present: $0)))
                    }
                )
            ) {
                SignUpView()
            }
            .sheet(
                isPresented: Binding(
                    get: { store.state.navigationState.isCreateWorkspaceViewPresented },
                    set: { store.dispatch(.navigationAction(.presentCreateWorkspaceView(present: $0)))
                    }
                )
            ) {
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
