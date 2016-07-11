//
//  NSFetchedResultsController+Convenience.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import Foundation
import CoreData

extension NSFetchedResultsController {
    
    convenience init(entityName: String, sortDescriptorKey: String, managedObjectContext: NSManagedObjectContext) {
        let fr = NSFetchRequest(entityName: entityName)
        fr.sortDescriptors = [
            NSSortDescriptor(key: sortDescriptorKey, ascending: true)
        ]
        self.init(fetchRequest: fr, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
}
