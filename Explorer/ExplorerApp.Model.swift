//
//  ExplorerApp.Model.swift
//  Explorer
//
//  Created by Etienne Vautherin on 26/02/2024.
//

extension ExplorerApp {
    class Model {
        static let shared = Model()
        private let running: Running
        
        init(
            runningStateValue: Running.State = .stopped
        ) {
            self.running = Running(initialState: runningStateValue)
        }
    }
}

// MARK: Running State handling
extension ExplorerApp.Model {
    func getRunningStateValue() -> Running.State {
        running.updates.value
    }
    
    func setRunningStateValue(_ value: Running.State) {
        running.updates.value = value
    }
    
    func assignRunningStateUpdates<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, Running.State>
    ) {
        Task { @MainActor in
            for await state in running.updates {
                receiver[keyPath: keyPath] = state
            }
        }
    }
}

