//
//  QuakesFRCDataSource.swift
//  Earthquakes-iOS
//
//  Created by Tomasz Lizer on 07/06/2023.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import CoreData

final class QuakesFRCDataSource: QuakesDataSource {
    private var frc: NSFetchedResultsController<Quake>
    
    var quakes: [Quake] {
        frc.fetchedObjects ?? []
    }
    
    init(context: NSManagedObjectContext) {
        let request = NSFetchRequest<Quake>()
        request.entity = Quake.entity()
        request.sortDescriptors = [
            NSSortDescriptor(key: "time", ascending: false)
        ]
        frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? frc.performFetch()
    }
}
