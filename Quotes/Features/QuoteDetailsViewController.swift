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
        
        self.contentLabel.text = viewModel.content
        self.authorLabel.text = viewModel.author
    }
}
