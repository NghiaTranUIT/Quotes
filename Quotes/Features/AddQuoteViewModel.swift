//
//  AddQuoteViewModel.swift
//  Quotes
//
//  Created by Tomasz Szulc on 16/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Model

struct AddQuoteViewModel {
    var contentText: String = ""
    var saidByText: String = ""
    
    var saveButtonEnabled: Bool {
        return contentText != "" && saidByText != ""
    }
    
    func saveQuote(context: NSManagedObjectContext) {
        let quote = Quote(content: contentText, author: saidByText, context: context)
        do { try context.save()
            // Index it
            if #available(iOS 9.0, *) {
                Quote.index([quote])
            }
        } catch let error as NSError {
            print("error during adding quote: \(error)")
        }
    }
}