//
//  ExplorerApp.swift
//  Explorer
//
//  Created by Etienne Vautherin on 25/02/2024.
//

import OSLog
import SwiftUI
import ActivityKit
import AsyncAlgorithms
import AsyncExtensions

let appLog = Logger()

@main
struct ExplorerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    static let scenePhaseValues = AsyncCurrentValueSubject<ScenePhase>(.background)

    let sharedActivityModel = ActivityModel()
    
    let runningStateUpdates = RunningService.shared.stateUpdates
    let activityEnablementUpdates = chain( AsyncJustSequence(ActivityKit.ActivityAuthorizationInfo().areActivitiesEnabled),
        ActivityKit.ActivityAuthorizationInfo().activityEnablementUpdates
    )
    
    init() {
        let activities = Activity<ExplorationActivity>.activities
        appLog.debug("\(activities)")
        let activityUptades = Activity<ExplorationActivity>.activityUpdates
        
        Task {
            for await activity in activityUptades {
                let description = String(describing: activity)
                appLog.debug("activityUptades activity: \(description)")
            }
        }
        
        let activityContent = combineLatest(
                runningStateUpdates,
                ExplorerApp.scenePhaseValues,
                activityEnablementUpdates
            )
            .compactMap { runningState, scenePhase, enablement -> ActivityContent<ExplorationActivity.ContentState>? in
                return ActivityContent<ExplorationActivity.ContentState>(
                    state: ExplorationActivity.ContentState(emoji: "", runningState: .stopped),
                    staleDate: .none
                )
//                ExplorationActivity.ContentState(emoji: "", runningState: .stopped)
            }
            .map { content in
                let a = try Activity.request(
                    attributes: ExplorationActivity(name: "Smile"),
                    content: content,
                    pushType: .none
                )
            }

        Task {
            for try await content in activityContent {
                
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ExplorationView()
        }
        .environment(ExplorationView.Model())
        .onChange(of: scenePhase) { oldPhase, newPhase in
            let decription = String(describing: self.scenePhase)
            appLog.debug("scenePhase: \(decription)")
            
            ExplorerApp.scenePhaseValues.send(newPhase)
            
            if newPhase == .background {
                // Perform cleanup when all scenes within
                // ExplorerApp go to the background.
            }
        }
    }
}
