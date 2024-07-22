//
//  MainTabView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/13/24.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject private var tabViewProvider = TabViewProvider()
    
    var body: some View {
        TabView(selection: $tabViewProvider.selectedTab) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                tab.view
                    .tabItem {
                        Image(tab.imageName)
                        Text(tab.title)
                    }
                    .tag(tab.rawValue)
            }
        }
        .environmentObject(tabViewProvider)
    }
}

#Preview {
    MainTabView()
}
