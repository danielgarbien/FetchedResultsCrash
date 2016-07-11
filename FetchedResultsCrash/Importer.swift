//
//  Importer.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import Foundation
import CoreData

class Importer {
    
    let dict = [
        "Jimmy": ["First note", "Second note", "Third note"],
        "Jimi": ["Ene", "Due"],
        "Jamie": ["Hello", "Goodbye"],
        "Jim": []
    ]
    
    func insertInitialDataToContext(context: NSManagedObjectContext) {
        context.performBlockAndWait {
            
            self.dict.forEach { name, notes in
                let person = Person.insertIntoManagedObjectContext(context)
                person.name = name
                person.image = name
                
                notes.forEach {
                    let note = Note.insertIntoManagedObjectContext(context)
                    note.text = $0
                    note.person = person
                }
            }
        }
    }
}
