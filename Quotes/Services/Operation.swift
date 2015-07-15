//
//  Operation.swift
//  Quotes
//
//  Created by Tomasz Szulc on 13/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

class Operation: NSOperation {
    private var finishInMain: Bool
    
    // keep track of executing and finished states
    private var _executing = false
    private var _finished = false

    init(completionBlock: (() -> Void)? = nil, finishInMain: Bool = true) {
        self.finishInMain = finishInMain
        super.init()
        self.completionBlock = completionBlock
        self.name = "custom"
    }
    
override func start() {
    if cancelled {
        finish()
        return
    }
    
    willChangeValueForKey("isExecuting")
    _executing = true
    didChangeValueForKey("isExecuting")
    // Call main, maybe other subclasses will want use it?
    // We have to call it manually when overriding `start`.
    main()
}
    
    override func main() {
        if cancelled == true && _finished != false {
            finish()
            return
        }
        
        if finishInMain { finish() }
    }
    
    /// If `finishInMain` is set to `false` you are responible to call
    /// `finish()` method when operation is about to finish.
    func finish() {        
        // Change isExecuting to `false` and isFinished to `true`.
        // Taks will be considered finished.
        willChangeValueForKey("isExecuting")
        willChangeValueForKey("isFinished")
        _executing = false
        _finished = true
        didChangeValueForKey("isExecuting")
        didChangeValueForKey("isFinished")
    }
    
    override var executing: Bool {
        return _executing
    }
    
    override var finished: Bool {
        return _finished
    }
    
    override func cancel() {
        super.cancel()
        finish()
    }
}
