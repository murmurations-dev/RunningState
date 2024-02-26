//
//  ExplorerApp.swift
//  Explorer
//
//  Created by Etienne Vautherin on 25/02/2024.
//

import OSLog
import SwiftUI

let appLog = Logger()

@main
struct ExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            ExplorationView()
        }
        .environment(ExplorationView.Model())
    }
}
