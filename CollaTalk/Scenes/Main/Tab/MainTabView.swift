//
//  MainTabView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/13/24.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTabIndex = MainTab.home.rawValue
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
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
