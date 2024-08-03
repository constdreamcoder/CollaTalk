//
//  CoinShopView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 8/4/24.
//

import SwiftUI

struct CoinShopView: View {
    
    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var navigationRouter: NavigationRouter
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                NavigationFrameView(
                    title: "코인샵",
                    leftButtonAction: {
                        navigationRouter.pop()
                    }
                )
                
                List {
                    Section {
                        HStack {
                            HStack {
                                Text("🪙 현재보유한 코인")
                                
                                Text("330개")
                                    .foregroundStyle(.brandGreen)
                            }
                            .font(.bodyBold)
                            
                            Spacer()
                            
                            Text("코인이란?")
                                .font(.caption)
                                .foregroundStyle(.textSecondary)
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    
                    Section {
                        ForEach(0..<3) { _ in
                            HStack {
                                Text("🪙 10 Coin")
                                    .font(.bodyBold)
                                    .foregroundStyle(.brandBlack)
                                
                                Spacer()
                                
                                Text("₩100")
                                    .font(.title2)
                                    .foregroundStyle(.brandWhite)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 16)
                                    .background(.brandGreen)
                                    .cornerRadius(4, corners: .allCorners)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        print("100원")
                                    }
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                }
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                
                Spacer()
            }
        }
    }
}

#Preview {
    CoinShopView()
}
