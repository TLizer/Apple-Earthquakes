//
//  ContentViewviewModelTests.swift
//  ContentViewModelTests
//
//  Created by Tomasz Lizer on 31/05/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import XCTest
@testable import Earthquakes

final class ContentViewModelTests: XCTestCase {

    func testTitleWithEmptySelection() {
        // Given ContentViewviewModel
        let provider = QuakesProvider.preview
        let viewModel = ContentViewModel(
            quakesProvider: provider,
            context: provider.container.viewContext
        )
        
        // When selection is empty
        viewModel.selection = []
        
        // Then title should be "Earthquakes"
        let title = viewModel.title
        XCTAssertEqual(title, "Earthquakes")
    }
    
    func testTitleWithTwoSelections() {
        // Given ContentViewviewModel
        let provider = QuakesProvider.preview
        let viewModel = ContentViewModel(
            quakesProvider: provider,
            context: provider.container.viewContext
        )
        
        // When selection contains two items
        viewModel.selection = ["1", "2"]
        
        // Then title should be "2 Selected"
        let title = viewModel.title
        XCTAssertEqual(title, "2 Selected")
    }
    
    func testTitleWithTwoSelectionsAndActiveMode() {
        // Given ContentViewviewModel
        let provider = QuakesProvider.preview
        let viewModel = ContentViewModel(
            quakesProvider: provider,
            context: provider.container.viewContext
        )
        
        // When selection contains two items but selectMode is active
        viewModel.selection = ["1", "2"]
        viewModel.selectMode = .active
        
        // Then title should be "Earthquakes"
        let title = viewModel.title
        XCTAssertEqual(title, "Earthquakes")
    }
    
    func testDeleteQuakesAtOffsetsDeleteSelection() {
        // Given ContentViewviewModel
        let provider = QuakesProvider.preview
        let viewModel = ContentViewModel(
            quakesProvider: provider,
            context: provider.container.viewContext
        )
        
        // When selection contains two items but selectMode is active
        viewModel.selection = ["1", "2"]
        
        // After delete quakes is performed
        viewModel.deleteQuakes(at: IndexSet())
        
        // Then title should be "Earthquakes"
        XCTAssertTrue(viewModel.selection.isEmpty)
    }
}
