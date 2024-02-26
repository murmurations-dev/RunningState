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
            switch model.runningState {
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
        var runningState: Running.State
        
        init(appModel: ExplorerApp.Model = ExplorerApp.Model.shared) {
            self.runningState = appModel.getRunningStateValue()
            appModel.assignRunningStateUpdates(to: self, on: \.runningState)
        }
    }
}
