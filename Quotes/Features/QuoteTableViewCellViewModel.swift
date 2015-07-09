//
//  QuoteTableViewCellViewModel.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Model

class QuoteTableViewCellViewModel {
    var quote: Quote
    
    init(quote: Quote) {
        self.quote = quote
    }
    
    var content: String {
        return quote.content
    }
    
    var author: String {
        return "-" + quote.author
    }
}