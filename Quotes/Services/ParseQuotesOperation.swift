//
//  ParseQuotesOperation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 11/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import Model

// It parses json content set as its property.
// It creates private queue councurrency type context to work on with overwrite 
// merge policy so we're sure that if there is some conflic it will be resolved 
// by using downloaded data.
// If objectId is not found then new object is created, otherwise it is updated.
// At the end passed context and its parent context are saved
class ParseQuotesOperation: NSOperation {
    var context: NSManagedObjectContext
    var json: Dictionary<String, AnyObject>!
    var semaphore = dispatch_semaphore_create(0)
    
    init(context: NSManagedObjectContext) {
        self.context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        self.context.parentContext = context
        self.context.mergePolicy = NSOverwriteMergePolicy
        super.init()
    }
    
    override func main() {
        guard let quotesJSON = json["results"] as? Array<Dictionary<String, AnyObject>> else { return }
        
        context.performBlock {
            // Find existing quote and update it or create new one
            for dictionary in quotesJSON {
                if let author = dictionary["author"] as? String,
                    let content = dictionary["content"] as? String,
                    let objectId = dictionary["objectId"] as? String {
                        if let quote = Quote.find(objectId, context: self.context) {
                            quote.author = author
                            quote.content = content
                        } else {
                            _ = Quote(content: content, author: author, objectId: objectId, context: self.context)
                        }
                } else {
                    print("Cannot parse \(dictionary)")
                }
            }
            
            self.saveContext()
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    private func saveContext() {
        if self.context.hasChanges {
            do { try self.context.save() } catch {}
            do { try self.context.parentContext?.save() } catch {}
            dispatch_semaphore_signal(semaphore)
        }
    }
}
