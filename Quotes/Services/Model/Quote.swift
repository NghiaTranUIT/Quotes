//
//  Quote.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

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
    
    init(_ context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Quote", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
}