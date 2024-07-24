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
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                
                SheetNavigation(
                    title: .changeWorkspaceOwner,
                    isPresented: Binding(
                        get: { store.state.navigationState.isChangeWorkspaceOwnerViewPresented },
                        set: { store.dispatch(.navigationAction(.presentChangeWorkspaceOwnerView(present: $0)))
                        }
                    ),
                    transitionAction: {}
                )
                
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
                
                Spacer()
            }
        }
        .onDisappear {
            store.dispatch(.changeWorkspaceOwnerAction(.initializeAllElements))
        }
        .onChange(of: store.state.changeWorkspaceOwnerState.workspaceMembers, action: { workspaceMembers in
            /// 관리자를 제외한 워크스페이스 멤버 수가 없을 때
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
        })
    }
}

#Preview {
    ChangeWorkspaceOwnerView()
}

struct ChangeWorkspaceOwnerViewCell: View {
    
    let workspaceMember: WorkspaceMember
    
    var body: some View {
        HStack(spacing: 8) {
            
            RemoteImage(
                path: workspaceMember.profileImage,
                imageView: { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 44)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                },
                placeHolderView: {
                    Image(.kakaoLogo)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 44)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                }
            )
            
            VStack {
                Text(workspaceMember.nickname)
                    .font(.bodyBold)
                    .foregroundStyle(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                
                Text(workspaceMember.email)
                    .font(.body)
                    .foregroundStyle(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
        }
    }
}
