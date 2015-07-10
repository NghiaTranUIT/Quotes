//
//  Quote.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

@objc (Quote)
public class Quote: NSManagedObject {
    @NSManaged public var author: String
    @NSManaged public var content: String
    @NSManaged private var identifierValue: String

    public var identifier: String {
        return identifierValue
    }
    
    public convenience init(content: String, author: String, context: NSManagedObjectContext) {
        self.init(context)
        self.content = content
        self.author = author
        self.identifierValue = NSUUID().UUIDString + "-\(NSDate().timeIntervalSince1970)"
    }
    
    convenience init(_ context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Quote", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    public class func find(identifier: String, context: NSManagedObjectContext) -> Quote? {
        let fetchRequest = quoteFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifierValue == %@", identifier)
        do {
            return try context.executeFetchRequest(fetchRequest).first as? Quote
        } catch {
            return nil
        }
    }
    
    public class func findAll(context: NSManagedObjectContext) -> [Quote] {
        let fetchRequest = quoteFetchRequest()
        do {
             if let result = try context.executeFetchRequest(fetchRequest) as? [Quote] {
                return result
            } else {
                return [Quote]()
            }
        } catch {
            return [Quote]()
        }
    }
    
    private class func quoteFetchRequest() -> NSFetchRequest {
        return NSFetchRequest(entityName: "Quote")
    }
}