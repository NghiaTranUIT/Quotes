//
//  QuoteResultsUpdater.swift
//  Quotes
//
//  Created by Tomasz Szulc on 10/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Model
import UIKit

class QuoteResultsUpdater: NSObject, UISearchResultsUpdating {
    var quotes = [Quote]()
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        var searchItems = [String]()
        if searchText != "" {
            searchItems = searchText.componentsSeparatedByString(" ")
        }
        
        var andMatchPredicates = [NSCompoundPredicate]()
        for searchItem in searchItems {
            var subPredicates = [NSPredicate]()
            subPredicates.append(NSPredicate(format: "content CONTAINS[c] %@", searchItem))
            subPredicates.append(NSPredicate(format: "author CONTAINS[c] %@", searchItem))
            let orMatchPredicate = NSCompoundPredicate.orPredicateWithSubpredicates(subPredicates)
            andMatchPredicates.append(orMatchPredicate)
        }
        
        let finalCompoundPredicate = NSCompoundPredicate.andPredicateWithSubpredicates(andMatchPredicates)
        let filteredQuotes = (quotes as NSArray).filteredArrayUsingPredicate(finalCompoundPredicate) as! [Quote]
        
        let tableController = searchController.searchResultsController as! QuoteListBaseTableViewController
        tableController.quotes = filteredQuotes
        tableController.tableView.reloadData()
    }
}
