//
//  HomeDefaultView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/12/24.
//

import SwiftUI


struct HomeDefaultView: View {
    
    var body: some View {
        VStack {
            HomeNaigationBar()
            
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
    }
}


#Preview {
    HomeDefaultView()
}

struct HomeNaigationBar: View {
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(.workspace)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .background(.brandGreen)
                    .frame(width: 32)
                    .cornerRadius(8, corners: .allCorners)
                
                Spacer()
                    .frame(width: 8)
                
                Text("No Workspace")
                    .font(.title1)
                    .lineLimit(1)
                
                Spacer()
                
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
            .padding(.horizontal, 16)
            
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

struct CellContent: View {
    
    let homeContentType: HomeContentType
    
    var body: some View {
        HStack {
            
            CellFrontPart(homeContentType: homeContentType)
            
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

struct HomeCell: View {
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
                    ForEach(0..<10) { _ in
                        CellContent(homeContentType: homeContentType)
                    }
                    
                    switch homeContentType {
                    case .channel:
                        AddNewCellView(contentType: .channel)
                    case .directMessage:
                        AddNewCellView(contentType: .directMessage)
                    }
                }
                
            }
            
            Divider()
        }
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

struct CellFrontPart: View {
    
    let homeContentType: HomeContentType
    private let unreadNumber = 99
    
    var body: some View {
        HStack {
            switch homeContentType {
            case .channel:
                Image(systemName: "number")
                    .foregroundStyle(unreadNumber > 0 ? .brandBlack : .textSecondary)
                    .frame(width: 18)
            case .directMessage:
                Image(.kakaoLogo)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 24)
                    .cornerRadius(4, corners: .allCorners)
            }
            
            
            Spacer()
                .frame(width: 16)
            
            Text("일반")
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
