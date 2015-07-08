//
//  QuoteSpec.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Quotes

class QuoteSpec: QuickSpec {
    override func spec() {
        describe("Quote") {
            it("is created and filled") {
                let quote = Quote(content: "A", author: "B")
                expect(quote.content).to(equal("A"))
                expect(quote.author).to(equal("B"))
            }
        }
    }
}