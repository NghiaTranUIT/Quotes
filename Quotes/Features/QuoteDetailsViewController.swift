//
//  QuoteDetailsViewController.swift
//  Quotes
//
//  Created by Tomasz Szulc on 09/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class QuoteDetailsViewController: UIViewController {
    @IBOutlet private var contentLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    
    var viewModel: QuoteViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentLabel.text = viewModel.content
        authorLabel.text = viewModel.author
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userActivity = viewModel.userActivity
        userActivity?.becomeCurrent()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        userActivity?.invalidate()
    }
    
    override func updateUserActivityState(activity: NSUserActivity) {
        activity.addUserInfoEntriesFromDictionary([QuoteUserActivityKey.Identifier.rawValue: viewModel.identifier])
        super.updateUserActivityState(activity)
    }
}
