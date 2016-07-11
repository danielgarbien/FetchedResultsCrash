//
//  SimpleTableViewController.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Trifork GmbH. All rights reserved.
//

import Foundation
import UIKit

class SimpleTableViewController: UIViewController {
    
    let dataSource: UITableViewDataSource
    
    init(dataSource: UITableViewDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var tableView = UITableView()
    
    override func loadView() {
        view = tableView
        tableView.dataSource = dataSource
    }
}

