//
//  RunningService.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//

import AppIntents
import AsyncExtensions

struct RunningService {
    typealias Sequence = AsyncCurrentValueSubject<State>
    typealias StateElement = State
    
    static let shared = RunningService(.stopped)
    let stateUpdates: Sequence
    
    init(_ initialStateValue: State) {
        self.stateUpdates = Sequence.init(initialStateValue)
    }
}

extension RunningService {
    enum State: String, Sendable, Codable {
        case stopped
        case started

        public static var typeDisplayRepresentation: TypeDisplayRepresentation {
            "Exploration"
        }
    }
}

extension RunningService.State : AppEnum {
    public static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .stopped: .init(title: "Stopped", image: .init(systemName: "location.slash")),
        .started: .init(title: "Started", image: .init(systemName: "location"))
    ]
}


