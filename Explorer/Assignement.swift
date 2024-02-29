//
//  Assignement.swift
//  Explorer
//
//  Created by Etienne Vautherin on 29/02/2024.
//

enum Assignement<Root, Element> {
    case simple
    case mainActor
    case withSupplementalAction((Element) -> ())
    case mainActorWithSupplementalAction((Element) -> ())

    func simpleAssign(
        _ element: Element,
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, Element>
    ) {
        receiver[keyPath: keyPath] = element
    }
    
    func assign(
        _ element: Element,
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, Element>
    ) {
        switch self {
        case .simple:
            simpleAssign(element, to: receiver, on: keyPath)

        case .mainActor:
            Task { @MainActor in simpleAssign(element, to: receiver, on: keyPath) }

        case .withSupplementalAction(let action):
            simpleAssign(element, to: receiver, on: keyPath)
            action(element)

        case .mainActorWithSupplementalAction(let action):
            Task { @MainActor in
                simpleAssign(element, to: receiver, on: keyPath)
                action(element)
            }
        }
    }
}

extension AsyncSequence {
    func assign<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, Element>,
        _ assignement: Assignement<Root, Element>
    ) -> AsyncObservation<Self> {
        AsyncObservation(self) { element in
            assignement.assign(element, to: receiver, on: keyPath)
        }
    }
}
