//
//  Quote+CoreSpotlight.swift
//  Quotes
//
//  Created by Tomasz Szulc on 10/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices
import Foundation
import Model

extension Quote {
    @available(iOS 9.0, *)
    func searchableItemAttributeSet() -> CSSearchableItemAttributeSet {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = "Quote from " + self.author
        attributeSet.contentDescription = self.content.fullTextOrExcerpt(100)
        attributeSet.keywords = ["reading", self.author]
        attributeSet.textContent = self.content
        return attributeSet
    }
    
    @available(iOS 9.0, *)
    class func index(quotes: [Quote]) {
        var searchableItems = [CSSearchableItem]()
        
        for quote in quotes {
            // Create set of attributes and searchable item
            let item = CSSearchableItem(uniqueIdentifier: quote.objectId, domainIdentifier: "com.tomaszszulc.Quotes", attributeSet: quote.searchableItemAttributeSet())
            searchableItems.append(item)
        }
        
        // Index
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(searchableItems, completionHandler: { (error) -> Void in
            if let error = error {
                print("error during indexing: \(error.localizedDescription)")
            } else {
                print("search items indexed")
            }
        })
    }
}