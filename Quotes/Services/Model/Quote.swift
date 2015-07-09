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
    @NSManaged public var content: String
    @NSManaged public var author: String
    
    public class func createQuote(content: String, author: String, context: NSManagedObjectContext) -> Quote {
        let quote = createQuote(context)
        quote.content = content
        quote.author = author
        return quote
    }
    
    private class func createQuote(context: NSManagedObjectContext) -> Quote {
        return NSEntityDescription.insertNewObjectForEntityForName("Quote", inManagedObjectContext: context) as! Quote
    }
}