//
//  SearchChannelView.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/30/24.
//

import SwiftUI

struct SearchChannelView: View {

    @EnvironmentObject private var store: AppStore
    @EnvironmentObject private var windowProvider: WindowProvider

    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            VStack {
                SheetNavigation(
                    title: .searchChannel,
                    isPresented: Binding(
                        get: { store.state.navigationState.isSearchChannelViewPresented },
                        set: { store.dispatch(.navigationAction(.presentSearchChannelView(present: $0, allChannels: []))) }
                    ),
                    transitionAction: {}
                )
                
                List {
                    ForEach(store.state.searchChannelState.allChannels, id: \.channelId) { channel in
                        HStack {
                            Image(systemName: "number")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 14)
                            
                            Text(channel.name)
                                .lineLimit(1)
                        }
                        .font(.bodyBold)
                        .foregroundStyle(.textPrimary)
                        .listRowSeparator(.hidden)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            store.dispatch(
                                .searchChannelAction(
                                    .compareIfMember(
                                        selectedChannel: channel,
                                        confirmAction: {
                                            print("채널 가입")
                                            windowProvider.dismissAlert()
                                            store.dispatch(.channelAction(.fetchChannelChats(chatRoomType: .channel, channel: channel)))
                                        }
                                    )
                                )
                            )
                        }
                    }
                }
                .listStyle(.plain)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SearchChannelView()
}
