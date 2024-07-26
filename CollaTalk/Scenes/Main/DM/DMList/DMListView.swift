//
//  DMListView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/22/24.
//

import SwiftUI

struct DMListView: View {
    
    var body: some View {
        VStack {
            DMMemberListView()
            
            Divider()
            
            DMRoomListView()
        }
    }
}

#Preview {
    DMListView()
}

struct DMMemberListView: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(store.state.workspaceState.workspaceMembers, id: \.userId) { workspaceMember  in
                    if store.state.user?.userId != workspaceMember.userId {
                        DMMemberCell(member: workspaceMember)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                store.dispatch(.dmAction(.createOrFetchChatRoom(chatRoomType: .dm, opponent: workspaceMember)))
                            }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .frame(height: 96)
    }
}

struct DMMemberCell: View {
    
    var member: WorkspaceMember
    
    var body: some View {
        VStack(spacing: 4) {
            
            RemoteImage(
                path: member.profileImage,
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
                },
                errorView: { _ in
                    Image(.kakaoLogo)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 44)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                }
            )
            
            Text(member.nickname)
                .font(.body)
        }
        .padding(16)
    }
}

struct DMRoomListView:View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        List {
            ForEach(store.state.dmState.dmRooms, id: \.roomId) { dmRoom in
                DMRoomListCell(dmRoom: dmRoom)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

struct DMRoomListCell: View {
    
    let dmRoom: LocalDMRoom
    
    var body: some View {
        HStack(alignment: .top) {
            RemoteImage(
                path: dmRoom.lastDM?.user?.profileImage,
                imageView: { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 34)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                },
                placeHolderView: {
                    Image(.kakaoLogo)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 34)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                },
                errorView: { error in
                    Image(.kakaoLogo)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 34)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                }
            )
            
            VStack {
                HStack {
                    Text(dmRoom.lastDM?.user?.nickname ?? "")
                        .font(.caption)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("PM 11:23")
                        .font(.caption2)
                        .foregroundStyle(.textSecondary)
                        .lineLimit(1)
                        .multilineTextAlignment(.trailing)
                }
                
                HStack(alignment: .top) {
                    Text(dmRoom.lastDM?.content ?? "")
                        .font(.caption2)
                        .foregroundStyle(.textSecondary)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(dmRoom.unreadDMCount)")
                        .font(.caption)
                        .foregroundColor(.brandWhite)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(.brandGreen)
                        .cornerRadius(8, corners: .allCorners)
                        .hidden(dmRoom.unreadDMCount <= 0)
                    
                }
            }
        }
    }
}
