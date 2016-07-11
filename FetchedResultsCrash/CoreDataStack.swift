//
//  CoreDataStack.swift
//  FetchedResultsCrash
//
//  Created by Daniel Garbień on 10/05/16.
//  Copyright © 2016 Daniel Garbień. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    
    let mainContext: NSManagedObjectContext
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    private let managedObjectModel: NSManagedObjectModel
    
    init(managedObjectModelName: String, storeType: String = NSSQLiteStoreType, configuration: String? = nil, URL storeURL: NSURL? = NSFileManager.defaultManager().defaultStoreURL(), options: [NSObject : AnyObject]? = nil) {
        managedObjectModel = NSManagedObjectModel(managedObjectModelName: managedObjectModelName)!
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel, storeType: storeType, configuration: configuration, URL: storeURL, options: options)
        mainContext = NSManagedObjectContext(storeCoordinator: persistentStoreCoordinator)
    }
}


extension NSFileManager {
    func defaultStoreURL() -> NSURL {
        let libraryDir = try! URLForDirectory(.LibraryDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        return libraryDir.URLByAppendingPathComponent("table")
    }
}


private extension NSManagedObjectModel {
    
    convenience init?(managedObjectModelName: String) {
        guard let modelURL = NSBundle.mainBundle().URLForResource(managedObjectModelName, withExtension: "momd") else {
            return nil
        }
        self.init(contentsOfURL: modelURL)
    }
}


private extension NSManagedObjectContext {
    
    convenience init(storeCoordinator: NSPersistentStoreCoordinator, concurrencyType: NSManagedObjectContextConcurrencyType = .MainQueueConcurrencyType) {
        self.init(concurrencyType: concurrencyType)
        persistentStoreCoordinator = storeCoordinator
    }
}


private extension NSPersistentStoreCoordinator {
    
    convenience init(managedObjectModel: NSManagedObjectModel, storeType: String, configuration: String?, URL storeURL: NSURL?, options: [NSObject : AnyObject]?) {
        self.init(managedObjectModel: managedObjectModel)
        addOrReplacePersistentStoreWithType(storeType, configuration: configuration, URL: storeURL, options: options)
    }
    
    func addOrReplacePersistentStoreWithType(storeType: String, configuration: String?, URL storeURL: NSURL?, options: [NSObject : AnyObject]?) {
        do {
            try addPersistentStoreWithType(storeType, configuration: configuration, URL: storeURL, options: options)
        }
        catch let error as NSError where error.domain == NSCocoaErrorDomain && error.code == NSPersistentStoreIncompatibleVersionHashError {
            // TODO migrate
            try! removePersistentStoreAtURL(storeURL!, type: storeType, options: options)
            return addOrReplacePersistentStoreWithType(storeType, configuration: configuration, URL: storeURL, options: options)
        }
        catch {
            fatalError(String(error))
        }
    }
    
    func removePersistentStoreAtURL(url: NSURL, type: String, options : [NSObject : AnyObject]?) throws {
        try destroyPersistentStoreAtURL(url, withType:type, options:options)
        try NSFileManager.defaultManager().removeItemAtURL(url)
    }
}
