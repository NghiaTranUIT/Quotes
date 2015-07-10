//
//  Quote+DebugPopulate.swift
//  Quotes
//
//  Created by Tomasz Szulc on 10/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Model

extension Quote {
    class func debugPopulate(context: NSManagedObjectContext) -> [Quote] {
        let quotesContent = [
            "Life is about making an impact, not making an income.",
            "Whatever the mind of man can conceive and believe, it can achieve.",
            "Two roads diverged in a wood, and I—I took the one less traveled by, And that has made all the difference.",
            "I attribute my success to this: I never gave or took any excuse.",
            "You miss 100% of the shots you don’t take.",
            "I’ve missed more than 9000 shots in my career. I’ve lost almost 300 games. 26 times I’ve been trusted to take the game winning shot and missed. I’ve failed over and over and over again in my life. And that is why I succeed."]
        
        let quotesAuthors = [
            "Kevin Kruse", "Napoleon Hill", "Robert Frost", "Florence Nightingale", "Wayne Gretzky", "Michael Jordan"
        ]
        
        var quotes = [Quote]()
        let context = CoreDataStack.sharedInstance().mainContext
        for idx in 0..<quotesContent.count {
            let quote = Quote(content: quotesContent[idx], author: quotesAuthors[idx], context: context)
            quotes.append(quote)
        }
        
        return quotes
    }
}