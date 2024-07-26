//
//  DMView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/22/24.
//

import SwiftUI

struct DMView: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        
        Group {
            if store.state.workspaceState.workspaceMembers.count > 0 {
                DMListView()
            } else {
                DMEmptyView()
            }
        }
        .task {
            print("Realm URL, \(LocalDMRoomRepository.shared.getLocationOfDefaultRealm())")
            store.dispatch(.dmAction(.configureView))
        }
    }
}

#Preview {
    DMView()
}
