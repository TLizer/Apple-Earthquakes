//
//  QuakesDataProvider.swift
//  EarthquakesTests
//
//  Created by Tomasz Lizer on 07/06/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import CoreData

protocol QuakesDataProvider {
    func deleteQuakes(identifiedBy objectIDs: [NSManagedObjectID])
    func deleteQuakes(_ quakes: [Quake]) async throws
    func fetchQuakes() async throws
}
