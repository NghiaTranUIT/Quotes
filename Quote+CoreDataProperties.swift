//
//  Quote+CoreDataProperties.swift
//  Quotes
//
//  Created by Tomasz Szulc on 12/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Quote {

    @NSManaged public var author: String
    @NSManaged public var content: String
    @NSManaged public var objectId: String
    @NSManaged public var readCount: NSNumber

}
