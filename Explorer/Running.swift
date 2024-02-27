//
//  Running.swift
//  Explorer
//
//  Created by Etienne Vautherin on 25/02/2024.
//

import AppIntents
import SwiftUI
import AsyncExtensions


protocol StateContainer {
    associatedtype State
    
    func setStateValue(_ newValue: State)
    func getStateValue() -> State
    func assignStateUpdates<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, Running.State>
    ) -> Task<(), Never>
}

protocol AsyncCurrentValueSubjectStateContainer : StateContainer {
    var updates: AsyncCurrentValueSubject<State> { get }
}

extension AsyncCurrentValueSubjectStateContainer {
    func setStateValue(_ newValue: State) { updates.value = newValue }
    func getStateValue() -> State { updates.value }
    func assignStateUpdates<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, State>
    ) -> Task<(), Never> {
        Task { @MainActor in
            for await state in updates {
                receiver[keyPath: keyPath] = state
            }
        }
    }
}


public struct Running {
    static let shared = Running(initialState: .stopped)
    let updates: AsyncCurrentValueSubject<State>
    
    init(initialState: State) {
        self.updates = AsyncCurrentValueSubject<State>(initialState)
    }
}

extension Running : AsyncCurrentValueSubjectStateContainer {}

public extension Running {
    enum State: String, Codable {
        case stopped
        case started

        public static var typeDisplayRepresentation: TypeDisplayRepresentation {
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
    public static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
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



