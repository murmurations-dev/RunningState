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
            switch model.serviceState {
            case .stopped:
                Button(
                    "Start",
                    intent: RunningService.State.SetStarted()
                ).padding()
            case .started:
                VStack {
                    ProgressView()
                    Button(
                        "Stop",
                        intent: RunningService.State.SetStopped()
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
        var serviceState: RunningService.State
        
        let runningService: RunningService
        var observation: AsyncObservation<RunningService.StateUpdates>?

        init(
            runningService: RunningService = RunningService.shared
        ) {
            self.runningService = runningService
            self.serviceState = runningService.getStateValue()
            self.observation = runningService.observeAsViewState(to: self, on: \.serviceState)
        }
    }
}
