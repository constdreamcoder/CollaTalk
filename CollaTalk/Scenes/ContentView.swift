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
    @EnvironmentObject private var windowProvider: WindowProvider
    
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
                    get: { store.state.navigationState.isModifyWorkspaceViewPresented },
                    set: { store.dispatch(.navigationAction(.presentModifyWorkspaceView(
                        present: $0,
                        workspaceModificationType: store.state.modifyWorkspaceState.workspaceModificationType)))
                    }
                )
            ) {
                ModifyWorkspaceView()
            }
            .sheet(
                isPresented: Binding(
                    get: { store.state.navigationState.isChangeWorkspaceOwnerViewPresented },
                    set: { store.dispatch(.navigationAction(.presentChangeWorkspaceOwnerView(present: $0))) }
                )
            ) {
               ChangeWorkspaceOwnerView()
            }
            .sheet(
                isPresented:Binding(
                    get: { store.state.navigationState.isInviteMemeberViewPresented },
                    set: { store.dispatch(.navigationAction(.presentInviteMemeberView(present: $0))) }
                )
            ) {
                    InviteMemberView()
            }
            .navigationDestination(for: PathType.self) { path in
                Group {
                    switch path {
                    case .startView:
                        WorkspaceStartView()
                    case .homeView:
                        MainView()
                    case .chatView:
                        ChatView()
                    case .none:
                        EmptyView()
                            .background(.clear)
                            .hidden()
                    }
                }
                .navigationBarBackButtonHidden()
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
        .onReceive(Just(store.state.alertState.dismissAlert)) { dismissAlert in
            if dismissAlert {
                windowProvider.dismissAlert()
            }
        }
        .onReceive(Just(store.state.alertState.showAlert)) { alertType, confirmAction in
            if alertType != .none {
                windowProvider.showAlert(
                    alertType: alertType,
                    confirmAction: confirmAction
                )
                store.dispatch(.alertAction(.initializeAllAlertElements))
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
                    store.dispatch(.navigationAction(.presentModifyWorkspaceView(present: false, workspaceModificationType: .create)))
                    store.dispatch(.initializeNetworkCallSuccessType)
                case .chatView:
                    break
                case .none: break
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
