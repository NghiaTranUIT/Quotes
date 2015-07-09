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
        
        userActivity = viewModel.userActivity
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userActivity?.becomeCurrent()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        userActivity?.invalidate()
    }
}
