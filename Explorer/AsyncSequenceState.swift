//
//  AsyncSequenceState.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//


protocol AsyncSequenceState<StateElement, Sequence> {
    associatedtype StateElement : Sendable
    associatedtype Sequence : AsyncSequence where Sequence.Element == StateElement
    
    var stateUpdates: Sequence { get }

    func setStateValue(_ newStateValue: StateElement)
    func getStateValue() -> StateElement
    func assignStateUpdates<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, StateElement>
    ) -> Task<(), Error>
}

extension AsyncSequenceState {
    func assignStateUpdates<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, StateElement>
    ) -> Task<(), Error> {
        Task { @MainActor in
            for try await state in stateUpdates {
                receiver[keyPath: keyPath] = state
            }
        }
    }
}
