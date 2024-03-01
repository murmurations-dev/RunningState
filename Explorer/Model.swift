//
//  Model.swift
//  Explorer
//
//  Created by Etienne Vautherin on 01/03/2024.
//

import CoreLocation
import AsyncAlgorithms
import AsyncExtensions

enum ServiceState : Decodable, Encodable, Hashable {
    case stopped
    case started
}

class Model {
    typealias ContentState = ServiceState
    typealias ContentUpdates = AsyncCurrentValueSubject<ContentState>
    
    var contentState: ContentState { contentStateUpdates.value }
    let contentStateUpdates: ContentUpdates
    
    // StateIn
    init(content: ContentState) {
        self.contentStateUpdates = ContentUpdates(content)
    }
    
    // StateIn
    func update(using content: ContentState) async {
        contentStateUpdates.value = content
    }
}

class LocationModel {
    typealias ContentState = CLLocationUpdate
    typealias ContentUpdates = CLLocationUpdate.Updates

    let contentStateUpdates: ContentUpdates
    
    init() {
        self.contentStateUpdates = CLLocationUpdate.liveUpdates()
    }
}

class CompositeModel {
    typealias ContentState = (Model.ContentState, CLLocationUpdate)
    typealias ContentUpdates = AsyncFlatMapSequence<Model.ContentUpdates, AnyAsyncSequence<CompositeModel.ContentState>>

    let contentStateUpdates: ContentUpdates
    let serviceModel: Model
    
    init(content: ServiceState) {
        self.serviceModel = Model(content: content)
        self.contentStateUpdates = serviceModel.contentStateUpdates
            .flatMap { serviceState in
                switch serviceState {
                case .stopped:
                    AsyncEmptySequence<CLLocationUpdate>()
                        .map { (serviceState, $0) }
                        .eraseToAnyAsyncSequence()
                    
                case .started:
                    LocationModel().contentStateUpdates
                        .map { (serviceState, $0) }
                        .eraseToAnyAsyncSequence()
                }
            }
    }
}

extension AsyncSequence {
    func assign<Root>(
        to receiver: Root,
        on keyPath: ReferenceWritableKeyPath<Root, Element>
    ) -> AsyncObservation<Self> {
        AsyncObservation(self) { element in
            receiver[keyPath: keyPath] = element
        }
    }
}
