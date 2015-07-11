//
//  DownloadAllQuotesOperation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 11/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData

class GetAllQuotesOperation: NSOperation, DownloadOperationDelegate {
    private var queue = NSOperationQueue()
    private var parseQuotesOp: ParseQuotesOperation!
    
    // Init operation with context which will be used during downloaded data 
    // parsing. From the context a child one will be created, after all is done 
    // child and this passed will be saved.
    // Completion handler is called by the last operation.
    init(context: NSManagedObjectContext, completionHandler: () -> Void) {
        super.init()
        name = "get.all.quotes"
        
        // Create download, parse and finish operations
        let request = NSMutableURLRequest.parseRequest("classes/Quote", method: "GET")
        let downloadOp = DownloadOperation(request: request, delegate: self)
        
        parseQuotesOp = ParseQuotesOperation(context: context)
        parseQuotesOp.addDependency(downloadOp)
        
        let finishOp = NSBlockOperation(block: completionHandler)
        finishOp.addDependency(parseQuotesOp)
        
        queue.addOperations([downloadOp, parseQuotesOp, finishOp], waitUntilFinished: false)
    }
    
    // MARK: - DownloadOperationDelegate
    // Delegate method that updates parsing operation with data to be parsed
    func downloadOperation(operation: DownloadOperation, didFinishDownloadingWithResult result: DownloadOperationResult) {
        if result.success {
            parseQuotesOp.json = result.json!
        } else {
            queue.cancelAllOperations()
        }
    }
}