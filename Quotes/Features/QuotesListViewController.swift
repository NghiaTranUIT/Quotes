//
//  ViewController.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices
import Model
import UIKit

private enum SegueIdentifier: String {
    case ShowQuote = "ShowQuote"
}

class QuotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private var tableView: UITableView!
    
    private var quotes = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        debug_populateQuotes()
    }
    
    private func debug_populateQuotes() {
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
        
        let context = CoreDataStack.sharedInstance().mainContext
        for idx in 0..<quotesContent.count {
            let quote = Quote(content: quotesContent[idx], author: quotesAuthors[idx], context: context)
            quotes.append(quote)
        }
        
        if #available(iOS 9.0, *) {
            var searchableItems = [CSSearchableItem]()
            
            for quote in quotes {
                let model = QuoteViewModel(quote: quote)
                // Create set of attributes and searchable item
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypePlainText as String)
                attributeSet.displayName = "Quote from " + quote.author
                attributeSet.title = "Quote"
                attributeSet.contentDescription = model.contentExcerpt
                attributeSet.keywords = [quote.author]
                
                let searchableItem = CSSearchableItem(uniqueIdentifier: quote.identifier, domainIdentifier: "com.tomaszszulc.Quotes.Quote", attributeSet: attributeSet)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch SegueIdentifier(rawValue: segue.identifier!)! {
        case .ShowQuote:
            let quoteDetailsVC = segue.destinationViewController as! QuoteDetailsViewController
            quoteDetailsVC.viewModel = QuoteViewModel(quote: sender as! Quote)
        }
    }
    
    // MARK: UITableViewDelegate & DataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(QuoteTableViewCell.Identifier, forIndexPath: indexPath) as! QuoteTableViewCell
        cell.viewModel = QuoteViewModel(quote: quotes[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(SegueIdentifier.ShowQuote.rawValue, sender: quotes[indexPath.row])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
}
