//
//  Operation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 13/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class Operation: NSOperation {
    
    private var startOnMainThread: Bool
    
    private var _executing = false
    private var _finished = false

    init(startOnMainThread: Bool = false) {
        self.startOnMainThread = startOnMainThread
        super.init()
    }
    
    override func start() {
        if startOnMainThread {
            // Check if start is on main thread.
            // If not, call it on main thread and wait for execution.
            if NSThread.isMainThread() == false {
                dispatch_async(dispatch_get_main_queue()) { self.start() }
                return
            }
        }
        
        print("operation \(self) started")
        
        _executing = true
        // Call main, maybe other subclasses will want use it?
        // We have to call it manually when overriding `start`.
        main()
    }
    
    override func main() {
        finish()
    }
    
    func finish() {
        print("operation \(self) finished")
        
        // Change isExecuting to `false` and isFinished to `true`.
        // Taks will be considered finished.
        _executing = false
        _finished = true
    }
    
    override var executing: Bool {
        return _executing
    }
    
    override var finished: Bool {
        return _finished
    }
}
