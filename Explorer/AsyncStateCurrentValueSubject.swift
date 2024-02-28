//
//  AsyncStateCurrentValueSubject.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//

import AsyncExtensions

protocol AsyncStateCurrentValueSubject : AsyncStateSequence
where Sequence == AsyncCurrentValueSubject<StateElement> {
    
}

extension AsyncStateCurrentValueSubject {
    func setStateValue(_ newStateValue: StateElement) {
        updates.value = newStateValue
    }
    
    func getStateValue() -> StateElement {
        updates.value
    }
    
    
    func assignStateUpdates<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, StateElement>
    ) -> Task<(), Never> {
        Task { @MainActor in
            for await state in updates {
                receiver[keyPath: keyPath] = state
            }
        }
    }
}

