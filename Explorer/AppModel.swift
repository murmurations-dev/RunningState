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

    let running: RunningService
    
    init(
        runningService: RunningService = RunningService.shared,
        runningStateValue: Running.State = .stopped
    ) {
        self.running = runningService
        explorationActivity(state: runningStateValue)
        
        Task {
            for await state in running.updates {
                explorationActivity(state: state)
            }
        }
    }
    
    func explorationActivity(state: Running.State) {
        switch state {
        case .stopped:
            guard let explorerActivity else { break }
            Task {
                let updatedState = ExplorationAttributes.ContentState(emoji: "🙄", runningState: .stopped)
                await explorerActivity.end(.init(state: updatedState, staleDate: .none), dismissalPolicy: .default)
            }
            self.explorerActivity = .none
            
        case .started:
            // guard foreground
            guard ActivityAuthorizationInfo().areActivitiesEnabled else {
                print("Activities are not enabled!")
                return
            }
            
            let exploration = ExplorationAttributes(name: "Smile")
            let initialState = ExplorationAttributes.ContentState(emoji: "😀", runningState: .started)
            
            do {
                self.explorerActivity = try Activity<ExplorationAttributes>.request(
                    attributes: exploration,
                    content: .init(state: initialState, staleDate: .none),
                    pushType: .none
                )
                
            } catch (let error) {
                print("Error: \(error.localizedDescription)")
            }

        }
    }
}

