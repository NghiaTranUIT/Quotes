//
//  NetworkOperation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 12/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

typealias NetworkOperationResult = (success: Bool, data: NSData?)
protocol NetworkOperationDelegate {
    func networkOperation(operation: NetworkOperation, didFinishWithResult result: NetworkOperationResult)
}

class NetworkOperation: NSOperation, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    private var connection: NSURLConnection!
    private var delegate: NetworkOperationDelegate!
    private var semaphore = dispatch_semaphore_create(0)
    
    init(request: NSURLRequest, delegate: NetworkOperationDelegate) {
        super.init()
        connection = NSURLConnection(request: request, delegate: self)
        self.delegate = delegate
    }
    
    override func main() {
        // NSURLConnection need to be started on the main thread
        dispatch_async(dispatch_get_main_queue()) { self.connection.start() }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    private func unlock() {
        dispatch_semaphore_signal(semaphore)
    }
    
    // MARK: - NSURLConnectionDelegate
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Error downloading quotes")
        delegate.networkOperation(self, didFinishWithResult: (false, nil))
        unlock()
    }
    
    // MARK: - NSURLConnectionDataDelegate
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        delegate.networkOperation(self, didFinishWithResult: (true, data))
        unlock()
    }
}
