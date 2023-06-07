//
//  FakeQuakesProvider.swift
//  EarthquakesTests
//
//  Created by Tomasz Lizer on 07/06/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import CoreData
@testable import Earthquakes

final class FakeQuakesProvider: QuakesDataProvider {
    
    private(set) var deleteQuakesCalledCount = 0
    private(set) var deleteQuakesLastCalledParams: [Quake]?
    func deleteQuakes(_ quakes: [Quake]) async throws {
        deleteQuakesCalledCount += 1
        deleteQuakesLastCalledParams = quakes
    }
    
    private(set) var deleteQuakesIdentifiedByCalledCount = 0
    private(set) var deleteQuakesIdentifiedByLastCalledParams: [NSManagedObjectID]?
    func deleteQuakes(identifiedBy objectIDs: [NSManagedObjectID]) {
        deleteQuakesIdentifiedByCalledCount += 1
        deleteQuakesIdentifiedByLastCalledParams = objectIDs
    }
    
    private(set) var fetchQuakesCalledCount = 0
    private(set) var fetchQuakesErrorMock: Error?
    func fetchQuakes() async throws {
        fetchQuakesCalledCount += 1
        if let fetchQuakesErrorMock {
            throw fetchQuakesErrorMock
        }
    }
}
