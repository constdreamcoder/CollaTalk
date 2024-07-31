//
//  ChangeChannelOwnerView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/31/24.
//

import SwiftUI

struct ChangeChannelOwnerView: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var windowProvider: WindowProvider
    
    var body: some View {
        ChangeOwnerViewFrame(
            isPresented: Binding(
                get: { store.state.navigationState.isChangeChannelOwnerViewPresented },
                set: { store.dispatch(.navigationAction(.presentChangeChannelOwnerView(present: $0))) }
            ),
            onDisappearAction: { store.dispatch(.changeWorkspaceOwnerAction(.initializeAllElements)) },
            onChangeValue: store.state.changeChannelOwnerState.channelMembers,
            onChangeAction: { channelMember in
                if channelMember.count >= 1 && (channelMember.count - 1) <= 0 {
                    store.dispatch(
                        .alertAction(
                            .showAlert(
                                alertType: .unableToChangeChannelOwner,
                                confirmAction: { windowProvider.dismissAlert() }
                            )
                        )
                    )
                }
            },
            content: {
                List {
                    ForEach(store.state.changeChannelOwnerState.channelMembers, id: \.userId) { channelMember in
                        if channelMember.userId != store.state.user?.userId ?? ""  {
                            ChangeChannelOwnerViewCell(channelMember: channelMember)
                                .listRowInsets(.init(top: 8, leading: 14, bottom: 8, trailing: 14))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
//                                    store.dispatch(
//                                        .alertAction(
//                                            .showAlert(
//                                                alertType: .changeWorkspaceOwner(newOwner: workspaceMember.nickname),
//                                                confirmAction: {
//                                                    store.dispatch(
//                                                        .changeWorkspaceOwnerAction(
//                                                            .changeWorkspaceOwnerShip(
//                                                                member: workspaceMember
//                                                            )
//                                                        )
//                                                    )
//                                                }
//                                            )
//                                        )
//                                    )
                                }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            },
            isChangingChannelOwnerShip: true
        )
        
    }
}

#Preview {
    ChangeChannelOwnerView()
}


struct ChangeChannelOwnerViewCell: View {
    
    let channelMember: WorkspaceMember
    
    var body: some View {
        ChangeOwnerViewCellFrame(
            profileImage: channelMember.profileImage,
            nickname: channelMember.nickname,
            email: channelMember.email
        )
    }
}
