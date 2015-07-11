//
//  DownloadOperation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 11/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

typealias DownloadOperationResult = (success: Bool, json: Dictionary<String, AnyObject>?)
protocol DownloadOperationDelegate {
    func downloadOperation(operation: DownloadOperation, didFinishDownloadingWithResult result: DownloadOperationResult)
}

// Operation uses internal connections to perform request passed in init method.
// After content is downloaded it convert NSData to json-like object and call 
// delegate method.
class DownloadOperation: NSOperation, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    private var connection: NSURLConnection!
    private var delegate: DownloadOperationDelegate!
    private var semaphore = dispatch_semaphore_create(0)

    init(request: NSURLRequest, delegate: DownloadOperationDelegate) {
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
    
    private func markFailed() {
        delegate.downloadOperation(self, didFinishDownloadingWithResult: (false, nil))
    }
    
    // MARK: - NSURLConnectionDelegate
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Error downloading quotes")
        markFailed()
        unlock()
    }
    
    // MARK: - NSURLConnectionDataDelegate
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? Dictionary<String, AnyObject> {
                delegate.downloadOperation(self, didFinishDownloadingWithResult: (true, json))
            }
        } catch {
            markFailed()
        }
        unlock()
    }
}
