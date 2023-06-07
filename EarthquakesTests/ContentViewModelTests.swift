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
    // Even though those properties are set once, nothing is being reused in between tests
    // XCTest creates separate instance of XCTestCase class for each test function
    let provider = FakeQuakesProvider()
    let dataSource = FakeQuakesDataSource()
    lazy var viewModel = ContentViewModel(
        quakesProvider: provider,
        dataSource: dataSource
    )

    func testTitleWithEmptySelection() {
        // When selection is empty
        viewModel.selection = []
        
        // Then title should be "Earthquakes"
        let title = viewModel.title
        XCTAssertEqual(title, "Earthquakes")
    }
    
    func testTitleWithTwoSelections() {
        // When selection contains two items
        viewModel.selection = ["1", "2"]
        
        // Then title should be "2 Selected"
        let title = viewModel.title
        XCTAssertEqual(title, "2 Selected")
    }
    
    func testTitleWithTwoSelectionsAndActiveMode() {
        // When selection contains two items but selectMode is active
        viewModel.selection = ["1", "2"]
        viewModel.selectMode = .active
        
        // Then title should be "Earthquakes"
        let title = viewModel.title
        XCTAssertEqual(title, "Earthquakes")
    }
    
    func testDeleteQuakesAtOffsetsDeleteSelection() {
        // When selection contains two items but selectMode is active
        viewModel.selection = ["1", "2"]
        
        // After delete quakes is performed
        viewModel.deleteQuakes(at: IndexSet())
        
        // Then title should be "Earthquakes"
        XCTAssertTrue(viewModel.selection.isEmpty)
    }
    
    // By default async functions are run on background threads managed by system.
    // If code in tests needs to run on main thread (eg UI snapshots)
    // then @MainActor can be used for that.
    @MainActor
    func testDeleteQuakesForCodesDeleteSelection() async {
        // When selection contains two items but selectMode is active
        viewModel.selection = ["1", "2"]
        
        XCTAssertEqual(provider.deleteQuakesCalledCount, 0)
        // After delete quakes is performed
        await viewModel.deleteQuakes(for: [])
        
        // Then title should be "Earthquakes"
        XCTAssertTrue(viewModel.selection.isEmpty)
        XCTAssertEqual(provider.deleteQuakesCalledCount, 1)
    }
    
    func testDeleteQuakesForCodesDeleteSelectionWithExpectation() {
        // When selection contains two items but selectMode is active
        viewModel.selection = ["1", "2"]
        print("Before callback")
        
        let expectation = self.expectation(description: "delete quakes")
        
        // Lets imagine we have interface that calls
        // completion handler upon finishing its task.
        // We need to "fulfill" expectation when work is finished
        // so we can later on perform asserts.
        Task { @MainActor in
            await viewModel.deleteQuakes(for: [])
            expectation.fulfill()
        }
        
        // After delete quakes is performed (here we wait for expectation to be fulfilled)
        waitForExpectations(timeout: 1)
        
        // Then selection should be empty
        XCTAssertTrue(viewModel.selection.isEmpty)
    }
    
    func testDeleteQuakesForCodesCallsProvider() async {
        XCTAssertEqual(provider.deleteQuakesCalledCount, 0)
        
        await viewModel.deleteQuakes(for: [])
        
        // Here we assert that deleteQuakes was called on provider only once
        XCTAssertEqual(provider.deleteQuakesCalledCount, 1)
    }
}
