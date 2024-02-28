//
//  RunningService.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//

import AsyncExtensions

struct Running : AppState {
    typealias StateElement = State
    
    static let shared: Running = Running(initialStateValue: .stopped)
    let updates: AsyncCurrentValueSubject<State>
    
    init(initialStateValue: State) {
        self.updates = AsyncCurrentValueSubject<State>(initialStateValue)
    }
}


