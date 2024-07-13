//
//  HomeView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/12/24.
//

import SwiftUI


struct HomeView: View {
    enum HomeContentType: CaseIterable {
        case channel
        case directMessage
        
        var title: String {
            switch self {
            case .channel:
                return "채널"
            case .directMessage:
                return "다이렉트 메시지"
            }
        }
        
        enum AddType: String {
            case channel = "채널 추가"
            case directMessage = "새 메시지 시작"
            case teamMember = "팀원 추가"
        }
    }
    
    var body: some View {
        VStack {
            HomeNaigationBar()
            
            
            //                        HomeEmptyView()
            
            
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
    HomeView()
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

struct HomeEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 35)
            
            Text("워크 스페이스를 찾을 수 없어요")
            //                .font(.title1)
                .padding(.horizontal, 24)
            
            
            Spacer()
                .frame(height: 24)
            
            Text("관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n 새로운 워크스페이스를 생성해주세요.")
            //                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 16)
            
            Image(.workspaceEmpty)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            
            Spacer()
            
            CustomButton {
                print("워크스페이스 생성")
            } label: {
                Text("워크스페이스 생성")
            }
            .bottomButtonShape(.brandGreen)
        }
    }
}

struct CellHeader: View {
    @Binding var isExpanded: Bool
    let homeContentType: HomeView.HomeContentType
    
    var body: some View {
        HStack {
            Text(homeContentType.title)
            //                            .font(.title2)
                .font(.system(size: 14, weight: .bold))
            
            Spacer()
            
            Image(systemName: isExpanded ? "chevron.down" : "chevron.forward")
            //                            .font(.title2)
                .font(.system(size: 14, weight: .bold))
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
    
    let homeContentType: HomeView.HomeContentType
    
    var body: some View {
        HStack {
            
            CellFrontPart(homeContentType: homeContentType)
            
            Text("99")
            //                            .font(.caption)
                .font(.system(size: 12, weight: .regular))
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
    let homeContentType: HomeView.HomeContentType
    
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
    
    let contentType: HomeView.HomeContentType.AddType
    
    var body: some View {
        HStack {
            Image(systemName: "plus")
                .foregroundStyle(.textSecondary)
                .frame(width: 18)
            
            Spacer()
                .frame(width: 16)
            
            Text(contentType.rawValue)
            //                            .font(.body)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(.textSecondary)
                .lineLimit(1)
            
            Spacer()
        }
        .frame(height: 41)
        
    }
}

struct CellFrontPart: View {
    
    let homeContentType: HomeView.HomeContentType
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
            //                            .font(.body)
                .font(unreadNumber > 0 ? .bodyBold : .system(size: 13, weight: .regular))
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
