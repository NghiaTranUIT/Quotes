//
//  QuoteTableViewCellViewModel.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Nimble
import Quick

@testable import Model
@testable import Quotes

class QuoteTableViewCellViewModelSpec: QuickSpec {
    override func spec() {
        describe("QouteTableViewCellViewModel") {
            
            beforeEach {
                CoreDataStack.setupTestableStore()
            }
            
            it("should return correct values") {
                let quote = Quote(content: "A", author: "B", context: CoreDataStack.sharedInstance().mainContext)
                let viewModel = QuoteTableViewCellViewModel(quote: quote)
                expect(viewModel.content).to(equal("A"))
                expect(viewModel.author).to(equal("-B"))
            }
        }
    }
}