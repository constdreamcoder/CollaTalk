//
//  MainView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/14/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        ZStack {
            VStack {
                MainNaigationBar()

                if store.state.workspaceState.workspaces.count == 0 {
                    HomeEmptyView()
                } else if store.state.workspaceState.workspaces.count >= 1 {
                    MainTabView()
                }
            }
        
            SideBar()
        }
        
    }
}

#Preview {
    MainView()
}
