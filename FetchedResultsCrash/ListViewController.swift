//
//  ListViewController.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ListViewControllerDelegate: class {
    
    func listViewController(viewController: ListViewController, didSelectPerson person: Person)
    func listViewController(viewController: ListViewController, didUpdateWithSelectedPerson person: Person?)
}

class ListViewController: UIViewController {
    
    weak var delegate: ListViewControllerDelegate?
    
    private let peopleFRC: NSFetchedResultsController
    init(peopleFRC: NSFetchedResultsController) {
        self.peopleFRC = peopleFRC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableViewController: SimpleTableViewController = {
        let tableVC = SimpleTableViewController(dataSource: self.dataSource)
        tableVC.tableView.delegate = self
        return tableVC
    }()
    private lazy var dataSource: UITableViewDataSource = {
        return FetchedResultsTableDataSource(
        fetchedResultController: self.peopleFRC) { tableView, indexPath, object in
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
            cell.textLabel?.text = (object as! Person).name
            return cell
        }
    }()
    private lazy var frcDelegate: NSFetchedResultsControllerDelegate = {
        let frcDelegate = FetchedResultsControllerTableDelegate(tableView: self.tableViewController.tableView)
        frcDelegate.didEndUpdates = { [unowned self] in
            self.delegate?.listViewController(self, didUpdateWithSelectedPerson: self.selectedPerson())
        }
        return frcDelegate
    }()
    
    private func selectedPerson() -> Person? {
        guard let indexPath = self.tableViewController.tableView.indexPathForSelectedRow else {
            return nil
        }
        return peopleFRC.objectAtIndexPath(indexPath) as? Person
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addImmediatelyChildViewController(tableViewController, embeddedInView: view)
        
        peopleFRC.delegate = frcDelegate
        try! peopleFRC.performFetch()
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.listViewController(self, didSelectPerson: selectedPerson()!)
    }
}
