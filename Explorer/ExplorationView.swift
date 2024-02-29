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
        
        let service: RunningService
        var observation: AsyncObservation<RunningService.StateUpdates>?

        init(
            service: RunningService = RunningService.shared
        ) {
            self.service = service
            self.serviceState = service.getStateValue()
            self.observation = service.assignStateUpdates(to: self, on: \.serviceState, .mainActor)
        }
    }
}
