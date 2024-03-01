//
//  ExplorationActivity.swift
//  Explorer
//
//  Created by Etienne Vautherin on 29/02/2024.
//

import ActivityKit

struct ExplorationActivity : ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
        var runningState: RunningService.State
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

