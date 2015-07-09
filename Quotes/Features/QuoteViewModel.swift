//
//  QuoteTableViewCellViewModel.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Model

class QuoteViewModel {
    private let quote: Quote
    
    init(quote: Quote) {
        self.quote = quote
    }
    
    var content: String {
        return "\"" + quote.content + "\""
    }
    
    var author: String {
        return "-" + quote.author
    }
    
    var contentExcerpt: String {
        if distance(content.startIndex, content.endIndex) > 20 {
            return content.excerpt(20) + "..."
        } else {
            return content
        }
    }
}
