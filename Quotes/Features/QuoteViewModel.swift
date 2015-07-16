//
//  QuoteTableViewCellViewModel.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Model

struct QuoteViewModel {
    let quote: Quote
    
    init(quote: Quote) {
        self.quote = quote
    }
    
    var content: String {
        return quote.content
    }
    
    var author: String {
        return quote.author.uppercaseString
    }
    
    var contentExcerpt: String {
        return content.excerpt(100)
    }
    
    var userActivity: NSUserActivity {
        return quote.userActivity
    }
    
    var identifier: String {
        return quote.objectId
    }
    
    var readCountString: String {
        if quote.readCount.integerValue == 1 {
            return "Read once"
        } else {
            return "Read \(quote.readCount) times"
        }
    }
    
    var showReadCount: Bool {
        return quote.readCount.integerValue != 0
    }
}
