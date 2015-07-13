//
//  ParseQuotesOperation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 11/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import Model

// Parses JSON content.
// Creates private queue to work with Core Data objects
// Creates or updates quote objects and save context before finish.
class ParseQuotesOperation: Operation {
    typealias JSONObject = Dictionary<String, AnyObject>
    
    private var context: NSManagedObjectContext
    var json: JSONObject!
    
    init(context: NSManagedObjectContext) {
        self.context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        self.context.parentContext = context
        self.context.mergePolicy = NSOverwriteMergePolicy
        super.init(finishInMain: false)
        self.name = "parse"
    }
    
    override func main() {
        if let results = json["results"] as? [JSONObject] {
            context.performBlock {
                // Find existing quote and update it or create new one
                for quoteJSON in results {
                    if let author = quoteJSON["author"] as? String,
                        let content = quoteJSON["content"] as? String,
                        let readCount = quoteJSON["readCount"] as? Int,
                        let objectId = quoteJSON["objectId"] as? String {
                            if let quote = Quote.find(objectId, context: self.context) {
                                quote.author = author
                                quote.content = content
                                quote.readCount = readCount
                            } else {
                                _ = Quote(content: content, author: author, readCount: readCount, objectId: objectId, context: self.context)
                            }
                    } else {
                        print("Cannot parse \(quoteJSON)")
                    }
                }
                
                self.saveContext()
            }
        } else {
            finish()
        }
    }
    
    private func saveContext() {
        if self.context.hasChanges {
            do { try self.context.save() } catch {}
            do { try self.context.parentContext?.save() } catch {}
        }
        finish()
    }
}
