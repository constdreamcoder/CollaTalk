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
        VStack {
            MainNaigationBar()
            
            ScrollView {
                ForEach(HomeContentType.allCases, id: \.title) { contentType in
                    HomeCell(homeContentType: contentType)
                }
                AddNewCellView(contentType: .teamMember)
            }
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
        }
        .overlay(alignment: .bottomTrailing) {
            NewMessageButton()
        }
        .task {
            store.dispatch(.workspaceAction(.fetchHomeDefaultViewDatas))
        }
    }
}


#Preview {
    HomeDefaultView()
}

struct HomeCell: View {
    
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
                        }
                        
                        AddNewCellView(contentType: .channel)
                    case .directMessage:
                        ForEach(store.state.workspaceState.dms, id: \.roomId) { dm in
                            DMCellContent(dm: dm)
                        }
                        
                        AddNewCellView(contentType: .directMessage)
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

struct DMCellContent: View {
    
    let dm: DM
    
    var body: some View {
        HStack {
            
            DMCellContent(dm: dm)
            
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

    let user: DMUser
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
    var body: some View {
        Button {
            print("새 메시지 생성")
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
