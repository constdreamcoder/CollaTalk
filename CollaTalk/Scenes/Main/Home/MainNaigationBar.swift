//
//  MainNaigationBar.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import SwiftUI

struct MainNaigationBar: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                
                RemoteImage(
                    path: store.state.workspaceState.selectedWorkspace?.coverImage ?? "",
                    imageView: { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .background(.brandGreen)
                            .frame(width: 32)
                            .cornerRadius(8, corners: .allCorners)
                    },
                    placeHolderView: {
                        Image(.workspace)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .background(.brandGreen)
                            .frame(width: 32)
                            .cornerRadius(8, corners: .allCorners)
                    },
                    errorView: { error in
                        Image(.workspace)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .background(.brandGreen)
                            .frame(width: 32)
                            .cornerRadius(8, corners: .allCorners)
                    }
                )
                
                Spacer()
                    .frame(width: 8)
                
                Text(store.state.workspaceState.selectedWorkspace?.name ?? "No Workspace")
                    .font(.title1)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(width: 16)
                
                RemoteImage(
                    path: store.state.user?.profileImage ?? "",
                    imageView: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(.brandGreen)
                            .frame(width: 32)
                            .clipShape(Circle())
                            .overlay (
                                Circle().stroke(.black, lineWidth: 2)
                            )
                            .padding(.leading, 8)
                    },
                    placeHolderView: {
                        Image(.workspace)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(.brandGreen)
                            .frame(width: 32)
                            .clipShape(Circle())
                            .overlay (
                                Circle().stroke(.black, lineWidth: 2)
                            )
                            .padding(.leading, 8)
                    },
                    errorView: { error in
                        Image(.workspace)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(.brandGreen)
                            .frame(width: 32)
                            .clipShape(Circle())
                            .overlay (
                                Circle().stroke(.black, lineWidth: 2)
                            )
                            .padding(.leading, 8)
                    }
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    store.dispatch(.editProfileAction(.fetchMyProfile))
                }
            }
            .padding(.horizontal, 16)
            
            Divider()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            store.dispatch(.workspaceAction(.toggleSideBarAction))
        }
    }
}

#Preview {
    MainNaigationBar()
}
