//
//  FetchedResultsTableDataSource.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FetchedResultsTableDataSource: NSObject {
    
    typealias CellForRowAtIndexPath = (tableView: UITableView, indexPath: NSIndexPath, object: AnyObject) -> UITableViewCell
    
    let fetchedResultController: NSFetchedResultsController
    private let cellForRowAtIndexPath: CellForRowAtIndexPath
    
    init(fetchedResultController: NSFetchedResultsController, cellForRowAtIndexPath: CellForRowAtIndexPath) {
        self.fetchedResultController = fetchedResultController
        self.cellForRowAtIndexPath = cellForRowAtIndexPath
    }
}

extension FetchedResultsTableDataSource: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = fetchedResultController.objectAtIndexPath(indexPath)
        return cellForRowAtIndexPath(tableView: tableView, indexPath: indexPath, object: object)
    }
}
