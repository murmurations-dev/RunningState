//
//  AsyncCurrentValueSubjectState.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//

import AsyncExtensions

protocol AsyncCurrentValueSubjectState : AsyncSequenceState
where Sequence == AsyncCurrentValueSubject<StateElement> {}

extension AsyncCurrentValueSubjectState {
    func setStateValue(_ newStateValue: StateElement) {
        stateUpdates.value = newStateValue
    }
    
    func getStateValue() -> StateElement {
        stateUpdates.value
    }
}

