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
                    get: { store.state.navigationState.isAddWorkspaceViewPresented },
                    set: { store.dispatch(.navigationAction(.presentAddWorkspaceView(present: $0))) }
                )
            ) {
                AddWorkspaceView()
            }
            .navigationDestination(for: PathType.self) { path in
                switch path {
                case .startView:
                    WorspaceStartView()
                case .homeView:
                    MainView()
                case .none:
                    EmptyView()
                        .background(.clear)
                        .hidden()
                }
            }
        }
        .environmentObject(navigationRouter)
        .onReceive(Just(store.state.isLoading)) { isLoading in
            if isLoading {
                windowProvider.showLoading()
            } else {
                windowProvider.dismissLoading()
            }
        }
        .onReceive(Just(store.state.showToast)) { showToast in
            if showToast {
                windowProvider.showToast(message: store.state.toastMessage)
                store.dispatch(.dismissToastMessage)
            }
        }
        .onReceive(Just(store.state.networkCallSuccessType)) { networkCallSuccessType in
            if !store.state.isLoading {
                switch networkCallSuccessType {
                case .startView:
                    navigationRouter.push(screen: .startView)
                    store.dispatch(.navigationAction(.presentSignUpView(present: false)))
                    store.dispatch(.initializeNetworkCallSuccessType)
                case .homeView:
                    if navigationRouter.route.last != .homeView {
                        navigationRouter.push(screen: .homeView)
                    }
                    store.dispatch(.navigationAction(.presentLoginView(present: false)))
                    store.dispatch(.navigationAction(.presentAddWorkspaceView(present: false)))
                    store.dispatch(.initializeNetworkCallSuccessType)
                case .none: break
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
