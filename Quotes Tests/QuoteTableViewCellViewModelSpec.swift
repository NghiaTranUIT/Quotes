//
//  QuoteTableViewCellViewModel.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Quotes

class QuoteTableViewCellViewModelSpec: QuickSpec {
    override func spec() {
        describe("QouteTableViewCellViewModel") {
            let quote = Quote(content: "A", author: "B")
            let viewModel = QuoteTableViewCellViewModel(quote: quote)
            expect(viewModel.content).to(equal("A"))
            expect(viewModel.author).to(equal("-B"))
        }
    }
}