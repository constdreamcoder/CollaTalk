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
                                Text("🪙 현재 보유한 코인")
                                
                                Text("\(store.state.myProfileState.myProfile?.sesacCoin ?? 0)개")
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
                        ForEach(store.state.coinShopState.coinItemList, id: \.item) { coinItem in
                            HStack {
                                Text("🪙 \(coinItem.item)")
                                    .font(.bodyBold)
                                    .foregroundStyle(.brandBlack)
                                
                                Spacer()
                                
                                Text("₩\(coinItem.amount)")
                                    .font(.title2)
                                    .foregroundStyle(.brandWhite)
                                    .frame(width: 74, height: 28)
                                    .background(.brandGreen)
                                    .cornerRadius(4, corners: .allCorners)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        print("\(coinItem.amount)원")
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
