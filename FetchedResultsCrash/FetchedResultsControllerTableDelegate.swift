//
//  FetchedResultsControllerTableDelegate.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FetchedResultsControllerTableDelegate: NSObject {
    
    let tableView: UITableView
    var preserveSelection: Bool = true
    var didEndUpdates: (() -> Void)?
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    private var selectedIndexPaths: TableViewIndexPathsController?
}

extension FetchedResultsControllerTableDelegate: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        if preserveSelection {
            selectedIndexPaths = TableViewIndexPathsController(indexPaths: tableView.indexPathsForSelectedRows ?? [])
        }
        
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
        
        selectedIndexPaths?.indexPaths.forEach {
            tableView.selectRowAtIndexPath($0, animated: false, scrollPosition: .None)
        }
        selectedIndexPaths = nil
        
        didEndUpdates?()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            selectedIndexPaths?.updateIndexPathsForDeletedIndexPath(indexPath!)
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
            selectedIndexPaths?.updateIndexPathsForInsertedIndexPath(newIndexPath!)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
            selectedIndexPaths?.updateIndexPathsForMovedIndexPathFrom(indexPath!, toIndexPath: newIndexPath!)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
            selectedIndexPaths?.updateIndexPathsForDeletedSection(sectionIndex)
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
            selectedIndexPaths?.updateIndexPathsForInsertedSection(sectionIndex)
        default:
            fatalError()
        }
    }
}

private class TableViewIndexPathsController {
    
    private(set) var indexPaths: [NSIndexPath]
    
    init(indexPaths: [NSIndexPath]) {
        let invalidIndexPaths = indexPaths.filter { $0.length != 2 }
        precondition(invalidIndexPaths.count == 0)
        self.indexPaths = indexPaths
    }
    
    func updateIndexPathsForDeletedIndexPath(indexPath: NSIndexPath) {
        precondition(indexPath.length == 2)
        if let indexPathToDelete = indexPaths.indexOf(indexPath) {
            indexPaths.removeAtIndex(indexPathToDelete)
        }
        
        shiftRowsForIndexPathsStartingFromIndexPath(indexPath.nextIndexPath(), by: -1)
    }
    
    func updateIndexPathsForInsertedIndexPath(newIndexPath: NSIndexPath) {
        precondition(newIndexPath.length == 2)
        shiftRowsForIndexPathsStartingFromIndexPath(newIndexPath, by: 1)
    }
    
    func updateIndexPathsForMovedIndexPathFrom(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
        precondition(indexPath.length == 2 && newIndexPath.length == 2)
        let movedIndexPathWasIncluded = indexPaths.contains(indexPath)
        
        if movedIndexPathWasIncluded {
            indexPaths.removeAtIndex(indexPaths.indexOf(indexPath)!)
        }
        
        shiftRowsForIndexPathsStartingFromIndexPath(indexPath.nextIndexPath(), by: -1)
        shiftRowsForIndexPathsStartingFromIndexPath(newIndexPath, by: 1)
        
        if movedIndexPathWasIncluded {
            indexPaths.append(newIndexPath)
        }
    }
    
    func updateIndexPathsForDeletedSection(section: Int) {
        indexPaths = indexPaths.filter { $0.section != section }
    }
    
    func updateIndexPathsForInsertedSection(section: Int) {
        shiftForwardSectionsForIndexPathsStartingFromSection(section)
    }
    
    private func shiftRowsForIndexPathsStartingFromIndexPath(startingIndexPath: NSIndexPath, by shiftValue: Int) {
        precondition(startingIndexPath.length == 2)
        indexPaths = indexPaths.map {
            guard $0.section == startingIndexPath.section && $0.row >= startingIndexPath.row else {
                return $0
            }
            return NSIndexPath(forRow: $0.row + shiftValue, inSection: $0.section)
        }
    }
    
    private func shiftForwardSectionsForIndexPathsStartingFromSection(section: Int) {
        indexPaths = indexPaths.map {
            guard $0.section >= section else {
                return $0
            }
            return NSIndexPath(forRow: $0.row, inSection: section + 1)
        }
    }
}

private extension NSIndexPath {
    
    func nextIndexPath() -> NSIndexPath {
        precondition(length == 2)
        return NSIndexPath(forRow: row+1, inSection: section)
    }
}
