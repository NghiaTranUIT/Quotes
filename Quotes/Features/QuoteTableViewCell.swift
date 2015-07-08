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

    @IBOutlet private weak var quoteLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    private var _viewModel: QuoteTableViewCellViewModel!
    var viewModel: QuoteTableViewCellViewModel {
        set {
            _viewModel = newValue
            quoteLabel.text = _viewModel.content
            authorLabel.text = _viewModel.author
        }
        
        get {
            return _viewModel
        }
    }
}
