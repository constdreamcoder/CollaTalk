//
//  DMEmptyView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/22/24.
//

import SwiftUI

struct DMEmptyView: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        VStack(spacing: 19) {
            Text("워크스페이스에\n멤버가 없어요.")
                .font(.title1)
                .multilineTextAlignment(.center)
            
            Text("새로운 팀원을 초대해보세요.")
                .font(.body)
            
            CustomButton {
                print("팀원 초대하기")
                
                if store.state.user?.userId == store.state.workspaceState.selectedWorkspace?.ownerId {
                    print("팀원 초대")
                    store.dispatch(.navigationAction(.presentInviteMemeberView(present: true)))
                } else {
                    print("팀원 초대 불가")
                    store.dispatch(.inviteMemeberAction(.showToastMessageForNoRightToInviteMember))
                }
            } label: {
                Text("팀원 초대하기")
            }
            .bottomButtonShape(.brandGreen)
        }
    }
}

#Preview {
    DMEmptyView()
}
