//
//  DownloadAllQuotesOperation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 11/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

class GetAllQuotesOperation: Operation, NetworkOperationDelegate {
    private var queue: NSOperationQueue!
    private var parseOp: ParseQuotesOperation!
    
    init(context: NSManagedObjectContext, completionHandler: () -> Void) {
        super.init(finishInMain: false)
        name = "get_all_quotes"
        
        // Create download, parse and finish operations
        let downloadOp = NetworkOperation(request: request(), delegate: self)
        
        parseOp = ParseQuotesOperation(context: context)
        parseOp.addDependency(downloadOp)
        
        let completionOp = NSBlockOperation(block: completionHandler)
        completionOp.addDependency(parseOp)
        
        let finishOp = NSBlockOperation(block: { self.finish() })
        finishOp.addDependency(completionOp)
        
        queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.name = "get_all_quotes_q"
        queue.addOperations([downloadOp, parseOp, completionOp, finishOp], waitUntilFinished: false)
    }
    
    private func request() -> NSURLRequest {
        return NSMutableURLRequest.parseRequest("classes/Quote", method: "GET")
    }
    
    // MARK: - NetworkOperationDelegate
    func networkOperation(operation: NetworkOperation, didFinishWithResult result: NetworkOperationResult) {
        if result.success {
            do {
                parseOp.json = try NSJSONSerialization.JSONObjectWithData(result.data!, options: NSJSONReadingOptions.MutableLeaves) as? Dictionary<String, AnyObject>
            } catch {
                queue.cancelAllOperations()
                finish()
            }
        } else {
            queue.cancelAllOperations()
            finish()
        }
    }
}