//
//  ChangeWorkspaceOwnerView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/20/24.
//

import SwiftUI

struct ChangeWorkspaceOwnerView: View {
    
    @EnvironmentObject private var store: AppStore
    
    var body: some View {
        ZStack {
            
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                
                SheetNavigation(
                    title: .changeWorkspaceOwner,
                    isPresented: Binding(
                        get: { store.state.navigationState.isChangeWorkspaceOwnerViewPresented },
                        set: { store.dispatch(.navigationAction(.presentChangeWorkspaceOwnerView(present: $0)))
                        }
                    ),
                    transitionAction: {}
                )
                
                
                List {
                    ForEach(0..<5) { _ in
                        ChangeWorkspaceOwnerViewCell()
                        .listRowInsets(.init(top: 8, leading: 14, bottom: 8, trailing: 14))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)

                Spacer()
            }
        }
    }
}

#Preview {
    ChangeWorkspaceOwnerView()
}

struct ChangeWorkspaceOwnerViewCell: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(.kakaoLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44)
                .background(.brandGreen)
                .cornerRadius(8, corners: .allCorners)
            
            VStack {
                Text("Courtney Henry")
                    .font(.bodyBold)
                    .foregroundStyle(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                
                Text("alma.lawson@example.com")
                    .font(.body)
                    .tint(.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
            }
        }
    }
}
