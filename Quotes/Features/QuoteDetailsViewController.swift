//
//  QuoteDetailsViewController.swift
//  Quotes
//
//  Created by Tomasz Szulc on 09/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit
import Model

class QuoteDetailsViewController: UIViewController {
    @IBOutlet private var contentLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var readCountLabel: UILabel!
    
    private var queue: NSOperationQueue!
    
    var viewModel: QuoteViewModel! {
        didSet {
            update()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureOperationQueue()
    }
    
    private func update() {
        contentLabel?.text = viewModel.content
        authorLabel?.text = viewModel.author
        readCountLabel?.text = viewModel.readCountString
        readCountLabel?.hidden = !viewModel.showReadCount
    }
    
    private func configureOperationQueue() {
        queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .UserInitiated
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        update()
        userActivity = viewModel.userActivity
        userActivity?.becomeCurrent()
        updateReadCount()
    }
    
    private func updateReadCount() {
        queue.addOperation(UpdateReadCountOperation(quote: viewModel.quote, completionHandler: {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let quote = Quote.find(self.viewModel.quote.objectId, context: CoreDataStack.sharedInstance().mainContext)
                self.viewModel = QuoteViewModel(quote: quote!)
            })
        }))
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        userActivity?.invalidate()
    }
}
