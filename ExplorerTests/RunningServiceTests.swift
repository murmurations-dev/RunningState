//
//  AppStateTests.swift
//  ExplorerTests
//
//  Created by Etienne Vautherin on 25/02/2024.
//

import XCTest
import AsyncExtensions
@testable import Explorer

// https://www.hackingwithswift.com/quick-start/concurrency/how-to-convert-an-asyncsequence-into-a-sequence
extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
    }
}

final class RunningServiceTests: XCTestCase {
    
    let sut = RunningService(.stopped)

    func testState() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        // *** Check that same consecutive values doesn't send update
        // *** Check multiple update consumers
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
