//
//  RunningService.State.swift
//  Explorer
//
//  Created by Etienne Vautherin on 28/02/2024.
//

import AppIntents

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
