//
//  ExplorerApp.swift
//  Explorer
//
//  Created by Etienne Vautherin on 25/02/2024.
//

import OSLog
import SwiftUI
import AsyncAlgorithms
import AsyncExtensions

let appLog = Logger()

@main
struct ExplorerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    static let scenePhaseValues = AsyncCurrentValueSubject<ScenePhase>(.background)

    let sharedActivityModel = ActivityModel()
    
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
