//
//  RunningService.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//

import AsyncExtensions

struct RunningService : AppState {
    typealias StateElement = State
    
    static let shared: RunningService = RunningService(initialStateValue: .stopped)
    let updates: AsyncCurrentValueSubject<State>
    
    init(initialStateValue: State) {
        self.updates = AsyncCurrentValueSubject<State>(initialStateValue)
    }
}


