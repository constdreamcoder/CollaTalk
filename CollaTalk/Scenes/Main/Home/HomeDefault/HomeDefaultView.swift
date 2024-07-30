//
//  HomeDefaultView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/12/24.
//

import SwiftUI

struct HomeDefaultView: View {
    
    @EnvironmentObject private var store: AppStore
    
    @State private var isDialogPresented: Bool = false
    
    var body: some View {
        ScrollView {
            ForEach(HomeContentType.allCases, id: \.title) { contentType in
                HomeCell(isDialogPresented: $isDialogPresented, homeContentType: contentType)
            }
            AddNewCellView(contentType: .teamMember)
                .contentShape(Rectangle())
                .onTapGesture {
                    if store.state.user?.userId == store.state.workspaceState.selectedWorkspace?.ownerId {
                        print("팀원 초대")
                        store.dispatch(.navigationAction(.presentInviteMemeberView(present: true)))
                    } else {
                        print("팀원 초대 불가")
                        store.dispatch(.inviteMemeberAction(.showToastMessageForNoRightToInviteMember))
                    }
                }
        }
        .padding(.horizontal, 16)
        .scrollIndicators(.hidden)
        .overlay(alignment: .bottomTrailing) {
            NewMessageButton()
        }
        .confirmationDialog("", isPresented: $isDialogPresented) {
            Button("채널 생성", role: .none) {
                store.dispatch(.navigationAction(.presentCreateNewChannelView(present: true)))
            }
            Button("채널 탐색", role: .none) {}
            Button("취소", role: .cancel) {}
        }
    }
}


#Preview {
    HomeDefaultView()
}

struct HomeCell: View {
    
    @Binding var isDialogPresented: Bool
    
    @EnvironmentObject private var store: AppStore
    @State private var isExpanded: Bool = false
    let homeContentType: HomeContentType
    
    var body: some View {
        VStack(spacing: 0) {
            CellHeader(
                isExpanded: $isExpanded,
                homeContentType: homeContentType
            )
            
            if isExpanded {
                VStack {
                    switch homeContentType {
                    case .channel:
                        ForEach(store.state.workspaceState.myChannels, id: \.channelId) { channel in
                            MyChannelCellContent(channel: channel)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    store.dispatch(.channelAction(.fetchChannelChats(chatRoomType: .channel, channel: channel.convertToChannel)))
                                }
                        }
                        
                        AddNewCellView(contentType: .channel)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isDialogPresented = true
                            }
                    case .directMessage:
                        ForEach(store.state.workspaceState.dmRooms, id: \.roomId) { dmRoom in
                            DMRoomCellContent(dmRoom: dmRoom)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    guard let opponent = dmRoom.opponent?.convertToWorkspaceMember else { return }
                                    store.dispatch(.dmAction(.createOrFetchChatRoom(chatRoomType: .dm, opponent: opponent)))
                                }
                        }
                        
                        AddNewCellView(contentType: .directMessage)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                store.dispatch(.tabAction(.moveToDMTabWithNetowrkCall))
                            }
                    }
                }
                
            }
            
            Divider()
        }
    }
}

struct CellHeader: View {
    @Binding var isExpanded: Bool
    let homeContentType: HomeContentType
    
    var body: some View {
        HStack {
            Text(homeContentType.title)
                .font(.title2)
            
            Spacer()
            
            Image(systemName: isExpanded ? "chevron.down" : "chevron.forward")
                .font(.title2)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }
        }
        .frame(height: 56)
    }
}

struct MyChannelCellContent: View {
    
    let channel: LocalChannel
    
    var body: some View {
        HStack {
            
            MyChennelCellFrontPart(
                name: channel.name,
                unreadNumber: channel.unreadChannelChatCount
            )
            
            if channel.unreadChannelChatCount > 0 {
                Text("\(channel.unreadChannelChatCount)")
                    .font(.caption)
                    .foregroundColor(.brandWhite)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(.brandGreen)
                    .cornerRadius(8, corners: .allCorners)
            }
        }
        .frame(height: 41)
    }
}

struct DMRoomCellContent: View {
    
    let dmRoom: LocalDMRoom
    
    var body: some View {
        HStack {
            
            DMCellFrontPart(
                opponent: dmRoom.opponent,
                unreadNumber: dmRoom.unreadDMCount
            )
            
            if dmRoom.unreadDMCount > 0 {
                Text("\(dmRoom.unreadDMCount)")
                    .font(.caption)
                    .foregroundColor(.brandWhite)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(.brandGreen)
                    .cornerRadius(8, corners: .allCorners)
            }
           
        }
        .frame(height: 41)
    }
}

struct AddNewCellView: View {
    
    let contentType: HomeContentType.AddType
    
    var body: some View {
        HStack {
            Image(systemName: "plus")
                .foregroundStyle(.textSecondary)
                .frame(width: 18)
            
            Spacer()
                .frame(width: 16)
            
            Text(contentType.rawValue)
                .font(.body)
                .foregroundStyle(.textSecondary)
                .lineLimit(1)
            
            Spacer()
        }
        .frame(height: 41)
        
    }
}

struct MyChennelCellFrontPart: View {
    
    let name: String
    let unreadNumber: Int
    
    var body: some View {
        HStack {
            
            Image(systemName: "number")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 18)
                .foregroundStyle(unreadNumber > 0 ? .brandBlack : .textSecondary)
            
            Spacer()
                .frame(width: 16)
            
            Text(name)
                .font(unreadNumber > 0 ? .bodyBold : .body)
                .foregroundStyle(unreadNumber > 0 ? .brandBlack : .textSecondary)
                .lineLimit(1)
            
            Spacer()
        }
    }
}

struct DMCellFrontPart: View {

    let opponent: LocalWorkspaceMember?
    let unreadNumber: Int
    
    var body: some View {
        HStack {
            RemoteImage(
                path: opponent?.profileImage,
                imageView: { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 24)
                },
                placeHolderView: {
                    Image(systemName: "number")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 24)
                },
                errorView: { error in
                    Image(systemName: "number")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 24)
                }
            )
            .cornerRadius(4, corners: .allCorners)
            .foregroundStyle(unreadNumber > 0 ? .brandBlack : .textSecondary)

           
            Spacer()
                .frame(width: 16)
            
            Text(opponent?.nickname ?? "")
                .font(unreadNumber > 0 ? .bodyBold : .body)
                .foregroundStyle(unreadNumber > 0 ? .brandBlack : .textSecondary)
                .lineLimit(1)
            
            Spacer()
        }
    }
}

struct NewMessageButton: View {
    
    @EnvironmentObject private var store: AppStore

    var body: some View {
        Button {
           print("새 메세지 생성")
            store.dispatch(.tabAction(.moveToDMTabWithNetowrkCall))
        } label: {
            Image(.newMessage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18, height: 18)
                .foregroundStyle(.white)
                .padding()
                .background(.brandGreen)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
        .padding(.trailing, 18)
        .padding(.bottom, 18)
    }
}
