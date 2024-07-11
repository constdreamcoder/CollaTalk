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
                case .mainView:
                    WorspaceInitView()
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
                case .mainView:
                    navigationRouter.push(screen: .mainView)
                    store.dispatch(.navigationAction(.presentSignUpView(present: false)))
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
