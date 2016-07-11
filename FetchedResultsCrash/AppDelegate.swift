//
//  AppDelegate.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coreData = CoreDataStack(managedObjectModelName: "FetchedResultsCrash")
    
    lazy var dao: Dao = Dao(context: self.coreData.mainContext)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Importer().insertInitialDataToContext(coreData.mainContext)
        
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        window?.rootViewController = WireframeViewController(wireframe: SplitWireframe(dao: dao))
        window?.makeKeyAndVisible()
        return true
    }
}
