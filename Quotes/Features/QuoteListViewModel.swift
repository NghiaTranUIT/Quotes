//
//  QuoteListViewModel.swift
//  Quotes
//
//  Created by Tomasz Szulc on 16/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Model

struct QuoteListViewModel {
    
    var searchControllerWasActive = false
    var searchControllerSearchFieldWasFirstResponder = false
    
    func fetchAll(context: NSManagedObjectContext) -> [Quote] {
        return Quote.findAll(context)
    }
    
    func userActivity() -> NSUserActivity {
        let activity = NSUserActivity(activityType: ActivityType.QuotesList.rawValue)
        activity.title = "Viewing Quotes List"
        return activity
    }
}