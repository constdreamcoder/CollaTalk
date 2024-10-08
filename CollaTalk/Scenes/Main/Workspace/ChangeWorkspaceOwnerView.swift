//
//  ChangeWorkspaceOwnerView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/20/24.
//

import SwiftUI
import Combine

struct ChangeWorkspaceOwnerView: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var windowProvider: WindowProvider
    
    var body: some View {
        ChangeOwnerViewFrame(
            isPresented: Binding(
                get: { store.state.navigationState.isChangeWorkspaceOwnerViewPresented },
                set: { store.dispatch(.navigationAction(.presentChangeWorkspaceOwnerView(present: $0))) }
            ),
            onDisappearAction: { store.dispatch(.changeWorkspaceOwnerAction(.initializeAllElements)) },
            onChangeValue: store.state.changeWorkspaceOwnerState.workspaceMembers,
            onChangeAction: { workspaceMembers in
                if workspaceMembers.count >= 1 && (workspaceMembers.count - 1) <= 0 {
                    store.dispatch(
                        .alertAction(
                            .showAlert(
                                alertType: .unableToChangeWorkspaceOwner,
                                confirmAction: { windowProvider.dismissAlert() }
                            )
                        )
                    )
                }
            },
            content: {
                List {
                    ForEach(store.state.changeWorkspaceOwnerState.workspaceMembers, id: \.userId) { workspaceMember in
                        if workspaceMember.userId != store.state.user?.userId ?? ""  {
                            ChangeWorkspaceOwnerViewCell(workspaceMember: workspaceMember)
                                .listRowInsets(.init(top: 8, leading: 14, bottom: 8, trailing: 14))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    store.dispatch(
                                        .alertAction(
                                            .showAlert(
                                                alertType: .changeWorkspaceOwner(newOwner: workspaceMember.nickname),
                                                confirmAction: {
                                                    store.dispatch(
                                                        .changeWorkspaceOwnerAction(
                                                            .changeWorkspaceOwnerShip(
                                                                member: workspaceMember
                                                            )
                                                        )
                                                    )
                                                }
                                            )
                                        )
                                    )
                                }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            }
        )
        
    }
}



#Preview {
    ChangeWorkspaceOwnerView()
}

struct ChangeWorkspaceOwnerViewCell: View {
    
    let workspaceMember: WorkspaceMember
    
    var body: some View {
        ChangeOwnerViewCellFrame(
            profileImage: workspaceMember.profileImage,
            nickname: workspaceMember.nickname,
            email: workspaceMember.email
        )
    }
}
