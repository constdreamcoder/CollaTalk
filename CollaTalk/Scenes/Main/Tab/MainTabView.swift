//
//  MainTabView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/13/24.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        TabView(
            selection: Binding(
                get: { store.state.tabState.currentTab },
                set: { tab, transaction in
                    switch tab {
                    case .home:
                        store.dispatch(.tabAction(.moveToHomeTab))
                    case .dm:
                        store.dispatch(.tabAction(.moveToDMTab))
                    case .search: break
                    case .setting: break
                    }
                }
            )
        ) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                tab.view
                    .tabItem {
                        Image(tab.imageName)
                        Text(tab.title)
                    }
                    .tag(tab.rawValue)
            }
        }
    }
}

#Preview {
    MainTabView()
}
