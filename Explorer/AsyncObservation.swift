//
//  AsyncCollector.swift
//  Explorer
//
//  Created by Etienne Vautherin on 29/02/2024.
//

class AsyncObservation<Base: AsyncSequence> {
    private let task: Task<(), Error>
    
    init(_ sequence: Base, action: @escaping (Base.Element) -> ()) {
        self.task = Task {
            for try await element in sequence {
                action(element)
            }
        }
    }
    
    deinit {
        task.cancel()
    }
}

extension AsyncSequence {
    func collectAsViewState<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, Element>
    ) -> AsyncObservation<Self> {
        AsyncObservation(self) { element in
            receiver[keyPath: keyPath] = element
        }
    }
}
