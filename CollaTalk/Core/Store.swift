//
//  Store.swift
//  CollaTalk
//
//  Created by SUCHAN CHANG on 7/8/24.
//

import Foundation
import Combine

typealias AppStore = Store<AppState, AppAction>

final class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State
    private let reducer: Reducer<State, Action>
    private let middlewares: [Middleware<State, Action>]
    private let queue = DispatchQueue(label: "serialQueue", qos: .userInitiated)
    private var subscriptions: Set<AnyCancellable> = []
    
    init(
        initial: State,
        reducer: @escaping Reducer<State, Action>,
        middlewares: [Middleware<State, Action>] = []
    ) {
        self.state = initial
        self.reducer = reducer
        self.middlewares = middlewares
    }
    
    func dispatch(_ action: Action) {
        queue.sync {
            self.dispatch(self.state, action)
        }
    }
    
    private func dispatch(_ currentState: State, _ action: Action) {
        let newState = reducer(currentState, action)
        
        middlewares.forEach { middleware in
            let publisher = middleware(newState, action)
            publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: dispatch)
                .store(in: &subscriptions)
        }
        
        state = newState
    }
}
