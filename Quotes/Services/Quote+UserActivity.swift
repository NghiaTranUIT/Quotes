//
//  Quote+UserActivity.swift
//  Quotes
//
//  Created by Tomasz Szulc on 10/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Model

enum QuoteUserActivityKey: String {
    case Identifier = "quote.identifier"
    case Content = "quote.content"
    case Author = "quote.author"
}

extension Quote {
    @available(iOS 8.0, *)
    var userActivity: NSUserActivity {
        let activity = NSUserActivity(activityType: ActivityType.BrowseQuote.rawValue)
        activity.title = "Reading " + self.author + " quote"
        activity.userInfo = [
            QuoteUserActivityKey.Identifier.rawValue: self.identifier,
            QuoteUserActivityKey.Content.rawValue: self.content,
            QuoteUserActivityKey.Author.rawValue: self.author
        ]
        // Core Spotlight support
        if #available(iOS 9.0, *) {
            activity.contentAttributeSet = self.searchableItemAttributeSet()
            activity.keywords = Set([self.author])
            activity.eligibleForSearch = true
            activity.eligibleForHandoff = true
        }
        
        return activity
    }
}