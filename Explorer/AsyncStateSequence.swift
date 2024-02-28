//
//  AsyncStateSequence.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//


protocol AsyncStateSequence<StateElement, Sequence> {
    associatedtype StateElement : Sendable
    associatedtype Sequence : AsyncSequence
    
    var updates: Sequence { get }

    func setStateValue(_ newStateValue: StateElement)
    func getStateValue() -> StateElement
    func assignStateUpdates<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, StateElement>
    ) -> Task<(), Never>
}
