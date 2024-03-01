//
//  ViewModel.swift
//  Explorer
//
//  Created by Etienne Vautherin on 01/03/2024.
//

import SwiftUI

@Observable
class ViewModel {
    var state: ServiceState
    var observation: AsyncObservation<Model.ContentUpdates>?
    
    init(model: Model) {
        self.state = model.contentState
        self.observation = model.contentStateUpdates.assign(to: self, on: \.state)
    }
}
