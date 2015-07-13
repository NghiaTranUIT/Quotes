//
//  NetworkOperation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 13/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

typealias NetworkOperationResult = (success: Bool, data: NSData?)
protocol NetworkOperationDelegate {
    func networkOperation(operation: NetworkOperation, didFinishWithResult result: NetworkOperationResult)
}

class NetworkOperation: Operation, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    private var connection: NSURLConnection!
    private var delegate: NetworkOperationDelegate!
    
    init(request: NSURLRequest, delegate: NetworkOperationDelegate) {
        super.init(startOnMainThread: true, finishInMain: false)
        connection = NSURLConnection(request: request, delegate: self)
        self.delegate = delegate
        self.name = "network"
    }
    
    override func start() {
        // Call super to start operation on main thread.
        // NSURLConnection must start on main thread.
        super.start()
        self.connection.start()
    }
    
    override func cancel() {
        connection.cancel()
        super.cancel()
    }
    
    // MARK: - NSURLConnectionDelegate
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        delegate.networkOperation(self, didFinishWithResult: (false, nil))
        finish()
    }
    
    // MARK: - NSURLConnectionDataDelegate
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        delegate.networkOperation(self, didFinishWithResult: (true, data))
        finish()
    }
}
