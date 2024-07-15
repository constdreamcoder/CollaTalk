//
//  HomeEmptyView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import SwiftUI

struct HomeEmptyView: View {
    var body: some View {
        VStack {
            HomeNaigationBar()
            
            HomeEmptyViewContent()
        }
    }
}

#Preview {
    HomeEmptyView()
}

struct HomeEmptyViewContent: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 35)
            
            Text("워크 스페이스를 찾을 수 없어요")
                .font(.title1)
                .padding(.horizontal, 24)
            
            
            Spacer()
                .frame(height: 24)
            
            Text("관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n 새로운 워크스페이스를 생성해주세요.")
                .font(.body)
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
                store.dispatch(.navigationAction(.presentAddWorkspaceView(present: true)))
            } label: {
                Text("워크스페이스 생성")
            }
            .bottomButtonShape(.brandGreen)
        }
    }
}
