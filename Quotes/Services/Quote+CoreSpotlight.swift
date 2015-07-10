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
    class func index(quotes: [Quote]) {
        var searchableItems = [CSSearchableItem]()
        
        for quote in quotes {
            let model = QuoteViewModel(quote: quote)
            // Create set of attributes and searchable item
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attributeSet.title = "Quote from " + quote.author
            attributeSet.contentDescription = model.contentExcerpt
            attributeSet.keywords = [quote.author]
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: quote.identifier, domainIdentifier: "com.tomaszszulc.Quotes", attributeSet: attributeSet)
            searchableItems.append(searchableItem)
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