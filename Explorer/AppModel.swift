//
//  AppModel.swift
//  Explorer
//
//  Created by Etienne Vautherin on 26/02/2024.
//

import ActivityKit

class AppModel {
    static let shared = AppModel()
    var explorerActivity: Activity<ExplorationAttributes>?

    private let running: Running
    
    init(
        runningStateValue: Running.State = .stopped
    ) {
        self.running = Running(initialState: runningStateValue)
    }
}

// MARK: Running State handling
extension AppModel {
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

