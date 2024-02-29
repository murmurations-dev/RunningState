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
    func assignStateUpdates<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, StateElement>,
        _ assignement: Assignement<Root, StateElement>
    ) -> AsyncObservation<StateUpdates>
}

extension AsyncSequenceState {
    func assignStateUpdates<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, StateElement>,
        _ assignement: Assignement<Root, StateElement>
    ) -> AsyncObservation<StateUpdates> {
        stateUpdates.assign(to: receiver, on: keyPath, assignement)
    }
}
