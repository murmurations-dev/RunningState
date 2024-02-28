//
//  RunningService.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//

import AsyncExtensions

struct RunningService : AsyncCurrentValueSubjectState {
    typealias Sequence = AsyncCurrentValueSubject<State>
    typealias StateElement = State
    
    static let shared = RunningService(.stopped)
    let stateUpdates: Sequence
    
    init(_ initialStateValue: State) {
        self.stateUpdates = Sequence.init(initialStateValue)
    }
}


