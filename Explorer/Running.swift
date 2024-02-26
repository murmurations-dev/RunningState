//
//  Running.swift
//  Explorer
//
//  Created by Etienne Vautherin on 25/02/2024.
//

import AppIntents
import SwiftUI
import AsyncExtensions


struct Running {
    let updates: AsyncCurrentValueSubject<State>
    
    init(initialState: State) {
        self.updates = AsyncCurrentValueSubject<State>(initialState)
    }
}

extension Running {
    enum State: String {
        case stopped
        case started

        static var typeDisplayRepresentation: TypeDisplayRepresentation {
            "Exploration"
        }
    }
}


extension Running.State {
    struct SetStarted {}
    struct SetStopped {}
    struct GetValue {}
}


extension Running.State : AppEnum {
    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .stopped: .init(title: "Stopped", image: .init(systemName: "location.slash")),
        .started: .init(title: "Started", image: .init(systemName: "location"))
    ]
}


extension Running.State.SetStarted : AppIntent {
    static let title: LocalizedStringResource = "Start exploration"
    static let description: IntentDescription? = """
            Start exploration.
    """
    
    var displayRepresentation: DisplayRepresentation {
        Running.State.caseDisplayRepresentations[.started] ?? ""
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let appModel = ExplorerApp.Model.shared
        appModel.setRunningStateValue(.started)
        return .result()
    }
}

extension Running.State.SetStopped : AppIntent {
    static let title: LocalizedStringResource = "Terminate exploration"
    static let description: IntentDescription? = """
            Terminate exploration.
    """
    
    var displayRepresentation: DisplayRepresentation {
        Running.State.caseDisplayRepresentations[.stopped] ?? ""
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let appModel = ExplorerApp.Model.shared
        appModel.setRunningStateValue(.stopped)
        return .result()
    }
}

extension Running.State.GetValue : AppIntent {
    static let title: LocalizedStringResource = "Exploration state"
    static let description: IntentDescription? = """
            Get exploration state.
    """
    
    var displayRepresentation: DisplayRepresentation {
        Running.State.caseDisplayRepresentations[.stopped] ?? ""
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Running.State> {
        let appModel = ExplorerApp.Model.shared
        let state = appModel.getRunningStateValue()
        return .result(value: state)
    }
}



