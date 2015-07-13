//
//  UpdateReadCountOperation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 13/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Model

class UpdateReadCountOperation: Operation, NetworkOperationDelegate {
    private var quote: Quote
    private var queue: NSOperationQueue!
    
    init(quote: Quote, completionBlock: () -> Void) {
        self.quote = quote
        super.init(finishInMain: false)
        name = "up_read_count"
        
        let updateOp = NetworkOperation(request: request(), delegate: self)
        let completionOp = NSBlockOperation(block: completionBlock)
        completionOp.addDependency(updateOp)
        let finishOp = NSBlockOperation { self.finish() }
        finishOp.addDependency(completionOp)
        
        queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "up_read_count_q"
        queue.addOperations([updateOp, completionOp, finishOp], waitUntilFinished: false)
    }
    
    private func request() -> NSURLRequest {
        return NSMutableURLRequest.parseRequest("functions/incrementReadCount",
            method: "POST", params: ["objectId": quote.objectId])
    }
    
    // MARK: - NetworkOperationDelegate
    typealias JSONObject = Dictionary<String, AnyObject>
    func networkOperation(operation: NetworkOperation, didFinishWithResult result: NetworkOperationResult) {
        guard result.success == true, let data = result.data else {
            queue.cancelAllOperations()
            return
        }
        
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as? JSONObject {
                if let readCount = (json["result"] as? [JSONObject])?.first?["readCount"] as? Int {
                    // update count
                    quote.readCount = NSNumber(integer: readCount)
                    
                    // save changes
                    if quote.hasChanges {
                        do {
                            try quote.managedObjectContext?.save()
                        } catch let error as NSError {
                            print("cannot save context: \(error)")
                        }
                    }
                }
            }
        } catch let error as NSError {
            print("cannot serialize data to json: \(error)")
            queue.cancelAllOperations()
            finish()
            return
        }
    }
}
