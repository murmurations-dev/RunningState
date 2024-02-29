//
//  AsyncSequenceState.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//


protocol AsyncSequenceState<StateElement, StateUpdates> {
    associatedtype StateElement : Sendable
    associatedtype StateUpdates : AsyncSequence where StateUpdates.Element == StateElement
    
    var stateUpdates: StateUpdates { get }

    func setStateValue(_ newStateValue: StateElement)
    func getStateValue() -> StateElement
    func observeAsViewState<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, StateElement>
    ) -> AsyncObservation<StateUpdates>
}

extension AsyncSequenceState {
    func observeAsViewState<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, StateElement>
    ) -> AsyncObservation<StateUpdates> {
        AsyncObservation(stateUpdates) { element in
            receiver[keyPath: keyPath] = element
        }
    }
}
