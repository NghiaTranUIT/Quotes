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
        if distance(content.startIndex, content.endIndex) > 100 {
            return content.excerpt(100) + "..."
        } else {
            return content
        }
    }
    
    var spotlightDisplayName: String {
        return "Quote from " + quote.author
    }
    
    var spotlightKeywords: [String] {
        return [quote.author, "quote"]
    }
    
    @available(iOS 8.0, *)
    var userActivity: NSUserActivity {
        let activity = NSUserActivity(activityType: ActivityType.BrowseQuote.rawValue)
        activity.title = spotlightDisplayName
        activity.userInfo = ["id": quote.identifier]
        
        // Core Spotlight support
        if #available(iOS 9.0, *) {
            activity.keywords = Set(spotlightKeywords)
            activity.eligibleForSearch = true
            activity.eligibleForHandoff = true
        }
        
        return activity
    }
}
