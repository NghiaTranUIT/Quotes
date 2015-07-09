//
//  CoreDataStack.swift
//  Quotes
//
//  Created by Tomasz Szulc on 09/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

public typealias CoreDataModelStoreType = String

public struct CoreDataModel {
    let name: String
    let bundle: NSBundle
    let sharedGroup: String?
    
    public init(name: String, bundle: NSBundle, sharedGroup: String? = nil) {
        self.name = name
        self.bundle = bundle
        self.sharedGroup = sharedGroup
    }
}

public class CoreDataStack: NSObject {
    private var model: CoreDataModel
    private var storeType: CoreDataModelStoreType
    private var concurrencyType: NSManagedObjectContextConcurrencyType
    
    public init(model: CoreDataModel, storeType: CoreDataModelStoreType, concurrencyType: NSManagedObjectContextConcurrencyType) {
        self.model = model
        self.storeType = storeType
        self.concurrencyType = concurrencyType
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contextDidSaveContext:"), name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    public class func setSharedInstance(shared: CoreDataStack) {
        Static.instance = shared
    }
    
    public class func sharedInstance() -> CoreDataStack {
        return Static.instance
    }
    
    // Return main context.
    public lazy var mainContext: NSManagedObjectContext! = {
        var context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
        }()
    
    // Return new temporary context
    public func createTemporaryContext(parent: NSManagedObjectContext!) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        context.parentContext = parent
        return context
    }
    
    /// Creates context and set main context as parent
    public func createTemporaryContextFromMainContext() -> NSManagedObjectContext {
        return self.createTemporaryContext(self.mainContext)
    }
    
    private struct Static {
        static var instance: CoreDataStack!
    }
    
    
    /// Private
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let model = NSManagedObjectModel(contentsOfURL: self.model.bundle.URLForResource(self.model.name, withExtension: "momd")!)!
        let coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let storeURL: NSURL?
        if let sharedGroup = self.model.sharedGroup {
            let sharedContainerURL: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(sharedGroup)!
            storeURL = sharedContainerURL.URLByAppendingPathComponent("\(self.model.name).sqlite")
        } else {
            storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("\(self.model.name).sqlite")
        }
        
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            abort()
        }
        
        return coordinator
        }()
    
    private func saveContext(context: NSManagedObjectContext) {
        guard context.hasChanges == false else { return }
        
        do {
            try context.save()
        } catch {
            print("Unresolved error")
            abort()
        }
    }
    
    func contextDidSaveContext(notification: NSNotification) {
//        print("contextDidSaveContext:")
    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        }()
}
