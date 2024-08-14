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
                       
                },
                placeHolderView: {
                    Image(.noProfilePhoto)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                },
                errorView: { _ in
                    Image(.noProfilePhoto)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                }
            )
            .frame(width: 44)
            .background(.brandGreen)
            .cornerRadius(8, corners: .allCorners)
            
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
            ForEach(store.state.workspaceState.dmRooms, id: \.roomId) { dmRoom in
                DMRoomListCell(dmRoom: dmRoom)
                .listRowSeparator(.hidden)
                .contentShape(Rectangle())
                .onTapGesture {
                    guard let opponent = dmRoom.opponent?.convertToWorkspaceMember else { return }
                    store.dispatch(.dmAction(.createOrFetchChatRoom(chatRoomType: .dm, opponent: opponent)))
                }
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
                path: dmRoom.opponent?.profileImage,
                imageView: { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                },
                placeHolderView: {
                    Image(.noProfilePhoto)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                },
                errorView: { error in
                    Image(.noProfilePhoto)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                }
            )
            .frame(width: 34)
            .background(.brandGreen)
            .cornerRadius(8, corners: .allCorners)
            
            VStack {
                HStack {
                    Text(dmRoom.opponent?.nickname ?? "")
                        .font(.caption)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
//                    Text("PM 11:23")
                    Text(dmRoom.lastDM?.createdAt.toDMTime ?? "")
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
