//
//  HomeDefaultView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/12/24.
//

import SwiftUI

struct HomeDefaultView: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        ScrollView {
            ForEach(HomeContentType.allCases, id: \.title) { contentType in
                HomeCell(homeContentType: contentType)
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
    }
}


#Preview {
    HomeDefaultView()
}

struct HomeCell: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var tabViewProvider: TabViewProvider
    
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
                        }
                        
                        AddNewCellView(contentType: .channel)
                    case .directMessage:
                        ForEach(store.state.workspaceState.dmRooms, id: \.roomId) { dmRooms in
                            DMRoomCellContent(dmRooms: dmRooms)
                        }
                        
                        AddNewCellView(contentType: .directMessage)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                tabViewProvider.selectedTab = .dm
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
    
    let channel: Channel
    
    var body: some View {
        HStack {
            
            MyChennelCellFrontPart(name: channel.name)
            
            Text("99")
                .font(.caption)
                .foregroundColor(.brandWhite)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(.brandGreen)
                .cornerRadius(8, corners: .allCorners)
        }
        .frame(height: 41)
    }
}

struct DMRoomCellContent: View {
    
    let dmRooms: DMRoom
    
    var body: some View {
        HStack {
            
            DMCellFrontPart(user: dmRooms.user)
            
            Text("99")
                .font(.caption)
                .foregroundColor(.brandWhite)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(.brandGreen)
                .cornerRadius(8, corners: .allCorners)
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
    private let unreadNumber = 99
    
    var body: some View {
        HStack {
            
            Image(systemName: "number")
                .foregroundStyle(unreadNumber > 0 ? .brandBlack : .textSecondary)
                .frame(width: 18)
            
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

    let user: WorkspaceMember
    private let unreadNumber = 99
    
    var body: some View {
        HStack {
            Image(systemName: "number")
                .foregroundStyle(unreadNumber > 0 ? .brandBlack : .textSecondary)
                .frame(width: 18)
            
            Spacer()
                .frame(width: 16)
            
            Text(user.nickname)
                .font(unreadNumber > 0 ? .bodyBold : .body)
                .foregroundStyle(unreadNumber > 0 ? .brandBlack : .textSecondary)
                .lineLimit(1)
            
            Spacer()
        }
    }
}

struct NewMessageButton: View {
    
    @EnvironmentObject private var tabViewProvider: TabViewProvider

    var body: some View {
        Button {
           print("새 메세지 생성")
            tabViewProvider.selectedTab = .dm
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
