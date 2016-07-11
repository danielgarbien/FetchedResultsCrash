//
//  Dao.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import Foundation
import CoreData

class Dao {
    
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func peopleFRC() -> NSFetchedResultsController {
        return SafeFetchedResultsController(entityName: "Person", sortDescriptorKey: "name", managedObjectContext: context)
    }
    
    func notesFRCForPerson(person: Person) -> NSFetchedResultsController {
        let frc = SafeFetchedResultsController(entityName: "Note", sortDescriptorKey: "text", managedObjectContext: context)
        frc.fetchRequest.predicate = NSPredicate(format: "person.name = %@", person.name)
        return frc
    }
    
    func deletePerson(person: Person) {
        context.performBlock {
            self.context.deleteObject(person)
        }
    }
}
