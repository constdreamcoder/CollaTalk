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
            if store.state.dmState.workspaceMembers.count > 0 {
                DMListView()
            } else {
                DMEmptyView()
            }
        }
        .task {
            store.dispatch(.dmAction(.configureView))
        }
    }
}

#Preview {
    DMView()
}
