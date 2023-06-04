//
//  ContentViewStateTests.swift
//  ContentViewStateTests
//
//  Created by Tomasz Lizer on 31/05/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import XCTest
@testable import Earthquakes

final class ContentViewStateTests: XCTestCase {

    func testTitleWithEmptySelection() {
        // Given ContentViewState
        let state = ContentViewState()
        
        // When selection is empty
        state.selection = []
        
        // Then title should be "Earthquakes"
        let title = state.title
        XCTAssertEqual(title, "Earthquakes")
    }
    
    func testTitleWithTwoSelections() {
        // Given ContentViewState
        let state = ContentViewState()
        
        // When selection contains two items
        state.selection = ["1", "2"]
        
        // Then title should be "2 Selected"
        let title = state.title
        XCTAssertEqual(title, "2 Selected")
    }
    
    func testTitleWithTwoSelectionsAndActiveMode() {
        // Given ContentViewState
        let state = ContentViewState()
        
        // When selection contains two items but selectMode is active
        state.selection = ["1", "2"]
        state.selectMode = .active
        
        // Then title should be "Earthquakes"
        let title = state.title
        XCTAssertEqual(title, "Earthquakes")
    }
}
