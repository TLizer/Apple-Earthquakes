//
//  ContentViewModel.swift
//  Earthquakes-iOS
//
//  Created by Tomasz Lizer on 28/05/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import SwiftUI
import CoreData

final class ContentViewModel: ObservableObject {
    private var quakesProvider: QuakesProvider
    private var frc: NSFetchedResultsController<Quake>
    
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
        frc.fetchedObjects ?? []
    }
    
    init(
        quakesProvider: QuakesProvider = .shared,
        context: NSManagedObjectContext
    ) {
        self.quakesProvider = quakesProvider
        let request = NSFetchRequest<Quake>()
        request.entity = Quake.entity()
        request.sortDescriptors = [
            NSSortDescriptor(key: "time", ascending: false)
        ]
        frc = .init(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? frc.performFetch()
    }
    
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
