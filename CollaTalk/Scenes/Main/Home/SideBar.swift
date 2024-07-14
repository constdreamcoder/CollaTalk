//
//  SideBar.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import SwiftUI

struct SideBar: View {
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(store.state.navigationState.isSidebarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: store.state.navigationState.isSidebarVisible)
            .onTapGesture {
//                isSidebarVisible.toggle()
                store.dispatch(.workspaceAction(.toggleSideBarAction))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SideBar()
}
