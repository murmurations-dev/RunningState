//
//  ActivityModel.swift
//  Explorer
//
//  Created by Etienne Vautherin on 27/02/2024.
//

import SwiftUI
import ActivityKit
import AsyncAlgorithms
import AsyncExtensions

@Observable
class ActivityModel {
    let runningService: RunningService
    let scenePhaseUpdates: AsyncCurrentValueSubject<ScenePhase>
    
    let activities = Activity<ExplorationActivity>.activities
    
    var explorerActivity: Activity<ExplorationActivity>?
    
    let activityEnablementUpdates = chain( AsyncJustSequence(ActivityKit.ActivityAuthorizationInfo().areActivitiesEnabled),
        ActivityKit.ActivityAuthorizationInfo().activityEnablementUpdates
    )

    private var startActivityUpdates: AsyncCompactMapSequence<some AsyncSequence, ()> {
//        let started = running.updates //.filter { $0 == .started }
//        let activeApp = scenePhaseUpdates //.filter { $0 == .active }
//            .removeDuplicates()
//            .handleEvents(onStart: {
//                appLog.debug("scenePhaseUpdates start")
//            }, onElement: { scenePhase in
//                let scenePhaseString = String(describing: scenePhase)
//                appLog.debug("scenePhaseUpdates onElement: \(scenePhaseString)")
//            }, onCancel: {
//                appLog.debug("scenePhaseUpdates cancel")
//            }, onFinish: { termination in
//                let terminationString = String(describing: termination)
//                appLog.debug("scenePhaseUpdates termination: \(terminationString)")
//            })
        combineLatest(runningService.stateUpdates, scenePhaseUpdates, activityEnablementUpdates)
            .map { started, activeApp, enabled -> Bool in
                let startedString = String(describing: started)
                let activeAppString = String(describing: activeApp)
                let enabledString = String(describing: enabled)
                appLog.debug("started: \(startedString), activeApp: \(activeAppString), enabled: \(enabledString)")
                guard enabled, activeApp == .active, started == .started else { return false }
                return true
//                switch activeApp {
//                case .background: return false
//                case .inactive: return false
//                case .active: return started == .started
//                @unknown default: return false
//                }
            }
            .handleEvents(onStart: {
                appLog.debug("map start")
            }, onElement: { scenePhase in
                let scenePhaseString = String(describing: scenePhase)
                appLog.debug("map onElement: \(scenePhaseString)")
            }, onCancel: {
                appLog.debug("map cancel")
            }, onFinish: { termination in
                let terminationString = String(describing: termination)
                appLog.debug("map termination: \(terminationString)")
            })
            .compactMap { start -> ()? in
                if start { return () } else { return .none }
            }
    }
    
    private var stopActivityUpdates: AsyncCompactMapSequence<some AsyncSequence, ()> {
        runningService.stateUpdates
            .map { started -> Bool in
                let startedString = String(describing: started)
                appLog.debug("started: \(startedString)")
                return started == .stopped
            }
            .compactMap { start -> ()? in
                if start { return () } else { return .none }
            }
    }

    init(
        scenePhaseUpdates: AsyncCurrentValueSubject<ScenePhase> = ExplorerApp.scenePhaseValues,
        runningService: RunningService = .shared
    ) {
        appLog.debug("ActivityModel init")
        self.runningService = runningService
        self.scenePhaseUpdates = scenePhaseUpdates
        
        Task {
            appLog.debug("Waiting startActivityUpdates")
            for try await _ in startActivityUpdates {
                startActivity()
            }
        }
        
        Task {
            appLog.debug("Waiting stopActivityUpdates")
            for try await _ in stopActivityUpdates {
                stopActivity()
            }
        }
    }
    
//    func startActivity_() throws {
//        let activityUpdates = AsyncThrowingStream<Activity<ExplorationAttributes>, Error>(
//            bufferingPolicy: .bufferingNewest(1)
//        ) { continuation in
//        }
//        
//        combineLatest(running.updates, scenePhaseUpdates, activityEnablementUpdates)
//            .compactMap { runningState, scenePhase, activityEnablement -> ()? in
//                return .none
//            }
//            .map { _ -> Activity<ExplorationAttributes> in
//                appLog.debug("Starting activity")
//                let exploration = ExplorationAttributes(name: "Smile")
//                let initialState = ExplorationAttributes.ContentState(emoji: "😀", runningState: .started)
//                
//                let activity = try Activity<ExplorationAttributes>.request(
//                    attributes: exploration,
//                    content: .init(state: initialState, staleDate: .none),
//                    pushType: .none
//                )
//                return activity
//            }
//            .flatMapLatest { activity in
//                combineLatest(activity.activityStateUpdates, Running.shared.updates)
//                    .compactMap { activityState, runningState -> Activity<ExplorationAttributes>? in
//                        return .none
//                    }
//                    .map { activityToEnd -> () in }
//            }
//    }
//    
//    func f() {
//        typealias State  = (
//            activity: Activity<ExplorationAttributes>?,
//            sequence: AnyAsyncSequence<ExplorationAttributes>?
//        )
//        
//        running.updates.scan((.none, .none)) { state, runningState -> State in
//            let (activity, sequence) = state
//            switch runningState {
//            case .stopped:
//                switch activity {
//                case .none: return (.none, .none)
//                case .some(let activity):
//                    return (.none, .none)
//                }
//            case .started:
//                switch activity {
//                case .none:
//                    return (.none, .none)
//                case .some(let activity): return (activity, .none)
//                }
//            }
//        }
//    }
    
    func startActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            appLog.error("Activities are not enabled!")
            return
        }
        
        appLog.debug("Starting activity")
        let exploration = ExplorationActivity(name: "Smile")
        let initialState = ExplorationActivity.ContentState(emoji: "😀", runningState: .started)
        
        do {
            self.explorerActivity = try Activity<ExplorationActivity>.request(
                attributes: exploration,
                content: .init(state: initialState, staleDate: .none),
                pushType: .none
            )
            
        } catch {
            appLog.error("Error: \(error.localizedDescription)")
        }
    }
    
    func stopActivity() {
        guard let explorerActivity else {
            appLog.error("No activity to stop!")
            return
        }
        appLog.debug("Stopping activity")
        Task {
            let updatedState = ExplorationActivity.ContentState(emoji: "🙄", runningState: .stopped)
            await explorerActivity.end(
                .init(state: updatedState, staleDate: .none),
                dismissalPolicy: .default
            )
            appLog.debug("Activity stopped")
            self.explorerActivity = .none
        }
    }
}
