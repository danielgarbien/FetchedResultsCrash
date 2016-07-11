//
//  SplitWireframe.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import Foundation
import UIKit

class SplitWireframe {
    
    private let dao: Dao
    init(dao: Dao) {
        self.dao = dao
    }
    
    private lazy var splitViewController: UISplitViewController = {
        let splitVC = UISplitViewController()
        splitVC.viewControllers = [self.listViewController]
        return splitVC
    }()
    
    private lazy var listViewController: ListViewController = {
        let vc = ListViewController(peopleFRC: self.dao.peopleFRC())
        vc.delegate = self
        return vc
    }()
}

extension SplitWireframe: Wireframe {
    
    var rootViewController: UIViewController {
        return splitViewController
    }
}

extension SplitWireframe: ListViewControllerDelegate {
    
    func listViewController(viewController: ListViewController, didSelectPerson person: Person) {
        showDetailViewControllerForPerson(person)
    }
    
    func listViewController(viewController: ListViewController, didUpdateWithSelectedPerson person: Person?) {
        showDetailViewControllerForPerson(person)
    }
    
    private func showDetailViewControllerForPerson(person: Person?){
        guard let person = person else {
            if let detailVC = splitViewController.viewControllers.last as? DetailViewController {
                detailVC.removeImmediatelyFromParentViewController()
            }
            return
        }
        let detailVC = DetailViewController(person: person, notesFRC: dao.notesFRCForPerson(person))
        detailVC.delegate = self
        splitViewController.showViewController(detailVC, sender: self)
    }
}

extension SplitWireframe: DetailViewControllerDelegate {
    
    func detailViewController(viewController: DetailViewController?, didDeletePerson person: Person) {
        dao.deletePerson(person)
    }
}
