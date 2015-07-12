//
//  UpdateReadCountOperation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 12/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import Model

class UpdateReadCountOperation: NSOperation, NetworkOperationDelegate {
    var queue: NSOperationQueue!
    var quote: Quote
    var finishOperation: NSBlockOperation
    
    init(quote: Quote, completionHandler: () -> Void) {
        self.quote = quote
        self.finishOperation = NSBlockOperation(block: completionHandler)
        super.init()
        
        let request = NSMutableURLRequest.parseRequest("functions/incrementReadCount", method: "POST", params: ["objectId": quote.objectId])
        let downloadOp = NetworkOperation(request: request, delegate: self)
        finishOperation.addDependency(downloadOp)
        
        queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "update.reading.count"
        queue.addOperations([downloadOp, finishOperation], waitUntilFinished: false)
    }
    
    func networkOperation(operation: NetworkOperation, didFinishWithResult result: NetworkOperationResult) {
        if result.success {
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(result.data!, options: NSJSONReadingOptions.MutableLeaves) as? Dictionary<String, AnyObject> {
                    if let readCount = (json["result"] as? Array<Dictionary<String, AnyObject>>)?.first?["readCount"] as? Int {
                        quote.readCount = NSNumber(integer: readCount)
                        if quote.hasChanges {
                            do { try quote.managedObjectContext?.save() } catch {}
                        }
                    }
                }
            } catch {
                queue.cancelAllOperations()
            }
        } else {
            queue.cancelAllOperations()
        }
    }
}
