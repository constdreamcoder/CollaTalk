//
//  NavigationRouter.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/11/24.
//

import SwiftUI

enum PathType: Hashable {
    case startView
    case homeView
    case chatView
    case channelSettingView
    case popFromChannelSettingViewToSideBar
    case popFromChannelSettingViewToHomeView
    case editProfileView
    case editNicknameView
    case editPhoneView
    case none
}

final class NavigationRouter: ObservableObject {
    @Published var route: [PathType]
    
    init() { 
        route = []
    }
    
    @MainActor
    func push(screen: PathType) {
        route.append(screen)
    }
    
    @MainActor
    func pop() {
        route.removeLast()
    }
    
    @MainActor
    func pop(depth: Int) {
        route.removeLast(depth)
    }
    
    @MainActor
    func popToRoot() {
        route.removeAll()
    }
    
    @MainActor
    func switchScreen(screen: PathType) {
        guard !route.isEmpty else { return }
        let lastIndex = route.count - 1
        route[lastIndex] = screen
    }
}
