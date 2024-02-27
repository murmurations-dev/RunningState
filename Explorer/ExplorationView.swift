//
//  ExplorationView.swift
//  Explorer
//
//  Created by Etienne Vautherin on 25/02/2024.
//

import SwiftUI
import AppIntents

struct ExplorationView: View {
    @Environment(ExplorationView.Model.self) var model

    var body: some View {
        VStack {
            switch model.state {
            case .stopped:
                Button(
                    "Start",
                    intent: Running.State.SetStarted()
                ).padding()
            case .started:
                VStack {
                    ProgressView()
                    Button(
                        "Stop",
                        intent: Running.State.SetStopped()
                    ).padding()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ExplorationView().environment(ExplorationView.Model())
}


extension ExplorationView {
    @Observable class Model {
        var state: Running.State
        
        let running = Running.shared
        var updatesTask: Task<(), Never>?

        init() {
            self.state = running.getStateValue()
            self.updatesTask = running.assignStateUpdates(to: self, on: \.state)
        }
        
        deinit {
            updatesTask?.cancel()
        }
    }
}
