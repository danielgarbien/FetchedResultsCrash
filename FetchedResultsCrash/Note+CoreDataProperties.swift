//
//  Note+CoreDataProperties.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Note {

    @NSManaged var text: String!
    @NSManaged var person: Person?

}
