//
//  RunningService_AppIntents.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//

import AppIntents

extension Running.State {
    struct SetStarted {}
    struct SetStopped {}
    struct GetValue {}
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
        let running = Running.shared
        running.setStateValue(.started)
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
        let running = Running.shared
        running.setStateValue(.stopped)
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
        let running = Running.shared
        let state = running.getStateValue()
        return .result(value: state)
    }
}



