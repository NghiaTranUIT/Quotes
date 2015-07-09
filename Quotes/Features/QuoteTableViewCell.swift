//
//  QuoteTableViewCell.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {
    static let Identifier: String = "QuoteTableViewCell"

    @IBOutlet private var quoteLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    
    var viewModel: QuoteViewModel! {
        didSet {
            quoteLabel?.text = viewModel.content
            authorLabel?.text = viewModel.author
        }
    }
}
