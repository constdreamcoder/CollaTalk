//
//  HomeView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/12/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HomeNaigationBar()
            
            Divider()
            
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
            } label: {
                Text("워크스페이스 생성")

            }
            .bottomButtonShape(.brandGreen)
        }
        
        

    }
}

#Preview {
    HomeView()
}

struct HomeNaigationBar: View {
    var body: some View {
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
    }
}
