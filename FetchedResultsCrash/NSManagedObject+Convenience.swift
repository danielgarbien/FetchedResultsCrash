//
//  NSManagedObject+Convenience.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import Foundation
import CoreData

protocol NSManagedObjectConveniences {}

extension NSManagedObjectConveniences {
    
    static func insertIntoManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> Self {
        let entityName = String(Self)
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)!
        let managedObject = NSManagedObject(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext) as! Self
        return managedObject
    }
}


extension NSManagedObject: NSManagedObjectConveniences {}
