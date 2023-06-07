//
//  ContentViewModel.swift
//  Earthquakes-iOS
//
//  Created by Tomasz Lizer on 28/05/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    // Here we are hiding dependencies behind protocol
    // This allows us to easily exchange actual implementations with mocks
    private var quakesProvider: QuakesDataProvider
    private var dataSource: QuakesDataSource
    
    @AppStorage("lastUpdated")
    var lastUpdated = Date.distantFuture.timeIntervalSince1970
    @Published var editMode: EditMode = .inactive
    @Published var selectMode: SelectMode = .inactive
    @Published var selection: Set<String> = []
    @Published var isLoading = false
    @Published var error: QuakeError?
    @Published var hasError = false
    
    var title: String {
        if selectMode.isActive || selection.isEmpty {
            return "Earthquakes"
        } else {
            return "\(selection.count) Selected"
        }
    }
    
    var refreshButtonDisabled: Bool {
        isLoading || editMode == .active
    }
    
    var deleteButtonDisabled: Bool {
        isLoading || selection.isEmpty
    }
    
    var showDeleteButton: Bool {
        editMode == .active
    }
    
    var quakes: [Quake] {
        dataSource.quakes
    }
    
    init(
        quakesProvider: QuakesDataProvider,
        dataSource: QuakesDataSource
    ) {
        self.quakesProvider = quakesProvider
        self.dataSource = dataSource
    }
    
    // By moving functions from view into ViewModel itself those has become testable
    func deleteQuakes(at offsets: IndexSet) {
        let objectIDs = offsets.map { quakes[$0].objectID }
        quakesProvider.deleteQuakes(identifiedBy: objectIDs)
        selection.removeAll()
    }

    func deleteQuakes(for codes: Set<String>) async {
        do {
            let quakesToDelete = quakes.filter { codes.contains($0.code) }
            try await quakesProvider.deleteQuakes(quakesToDelete)
        } catch {
            self.error = error as? QuakeError ?? .unexpectedError(error: error)
            hasError = true
        }
        selection.removeAll()
        editMode = .inactive
    }

    func fetchQuakes() async {
        isLoading = true
        do {
            try await quakesProvider.fetchQuakes()
            lastUpdated = Date().timeIntervalSince1970
        } catch {
            self.error = error as? QuakeError ?? .unexpectedError(error: error)
            hasError = true
        }
        isLoading = false
    }
}
