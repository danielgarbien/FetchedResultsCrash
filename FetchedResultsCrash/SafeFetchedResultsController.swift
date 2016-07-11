//
//  SafeFetchedResultsController.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 12/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import Foundation
import CoreData

class SafeFetchedResultsController: NSFetchedResultsController {
    
    private weak var safeDelegate: NSFetchedResultsControllerDelegate?
    
    override var delegate: NSFetchedResultsControllerDelegate? {
        get {
            return safeDelegate
        }
        set {
            safeDelegate = newValue
            super.delegate = newValue
        }
    }
}
