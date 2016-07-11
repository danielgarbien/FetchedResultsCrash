//
//  DetailViewController.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol DetailViewControllerDelegate: class {
    
    func detailViewController(viewController: DetailViewController?, didDeletePerson person: Person)
}

class DetailViewController: UIViewController {
    
    weak var delegate: DetailViewControllerDelegate?
    
    let person: Person
    let notesFRC: NSFetchedResultsController
    init(person: Person, notesFRC: NSFetchedResultsController) {
        self.person = person
        self.notesFRC = notesFRC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesFRC.delegate = frcDelegate
        try! notesFRC.performFetch()
    }
    
    private lazy var dataSource: UITableViewDataSource = {
        return FetchedResultsTableDataSource(
        fetchedResultController: self.notesFRC) { tableView, indexPath, object in
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
            cell.textLabel?.text = (object as! Note).text
            return cell
        }
    }()
    private lazy var frcDelegate: NSFetchedResultsControllerDelegate? = FetchedResultsControllerTableDelegate(tableView: self.tableView)
    
    @IBOutlet private weak var imageView: UIImageView! {
        didSet { imageView.image = UIImage(named: person.image) }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet { tableView.dataSource = self.dataSource }
    }
}

private extension DetailViewController {
    
    @IBAction func deleteTapped() {
        delegate?.detailViewController(nil, didDeletePerson: person)
    }
}
