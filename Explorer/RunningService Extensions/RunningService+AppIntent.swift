//
//  RunningService_AppIntents.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//

import AppIntents

extension RunningService.State {
    struct SetStarted {}
    struct SetStopped {}
    struct GetValue {}
}

extension RunningService.State.SetStarted : AppIntent {
    static let title: LocalizedStringResource = "Start exploration"
    static let description: IntentDescription? = """
            Start exploration.
    """
    
    var displayRepresentation: DisplayRepresentation {
        RunningService.State.caseDisplayRepresentations[.started] ?? ""
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let running = RunningService.shared
        running.setStateValue(.started)
        return .result()
    }
}

extension RunningService.State.SetStopped : AppIntent {
    static let title: LocalizedStringResource = "Terminate exploration"
    static let description: IntentDescription? = """
            Terminate exploration.
    """
    
    var displayRepresentation: DisplayRepresentation {
        RunningService.State.caseDisplayRepresentations[.stopped] ?? ""
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let running = RunningService.shared
        running.setStateValue(.stopped)
        return .result()
    }
}

extension RunningService.State.GetValue : AppIntent {
    static let title: LocalizedStringResource = "Exploration state"
    static let description: IntentDescription? = """
            Get exploration state.
    """
    
    var displayRepresentation: DisplayRepresentation {
        RunningService.State.caseDisplayRepresentations[.stopped] ?? ""
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<RunningService.State> {
        let running = RunningService.shared
        let state = running.getStateValue()
        return .result(value: state)
    }
}



