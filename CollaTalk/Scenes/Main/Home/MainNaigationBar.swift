//
//  MainNaigationBar.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import SwiftUI

struct MainNaigationBar: View {
    
    @EnvironmentObject private var store: AppStore
    
    private let path = UserDefaultsManager.getObject(forKey: .userInfo, as: UserInfo.self)?.profileImage
    
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(width: 16)
                
                RemoteImage(path: path) { image in
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
                } placeHolderView: {
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
