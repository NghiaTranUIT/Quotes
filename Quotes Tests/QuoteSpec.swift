//
//  QuoteSpec.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import CoreData
import Nimble
import Quick

@testable import Model
@testable import Quotes

class QuoteSpec: QuickSpec {
    override func spec() {
        describe("Quote") {
            
            beforeSuite {
                CoreDataStack.setupTestableStore()
            }
            
            it("is created and filled") {
                let quote = Quote.createQuote("A", author: "B", context: CoreDataStack.sharedInstance().mainContext)
                expect(quote.content).to(equal("A"))
                expect(quote.author).to(equal("B"))
            }
        }
    }
}