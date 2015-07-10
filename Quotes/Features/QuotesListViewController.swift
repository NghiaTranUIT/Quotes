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
        quotes = Quote.findAll(CoreDataStack.sharedInstance().mainContext)
    }
    
    private func debug_populateQuotes() {
        let populatedQuotes = Quote.debugPopulate(CoreDataStack.sharedInstance().mainContext)
        quotes += populatedQuotes

        if #available(iOS 9.0, *) {
            Quote.index(populatedQuotes)
        }
        
        do {
            try CoreDataStack.sharedInstance().mainContext.save()
        } catch {
            /// do nothing
        }
    }
    
    @IBAction func populateQuotes(sender: AnyObject) {
        debug_populateQuotes()
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch SegueIdentifier(rawValue: segue.identifier!)! {
        case .ShowQuote:
            let quoteDetailsVC = segue.destinationViewController as! QuoteDetailsViewController
            quoteDetailsVC.viewModel = QuoteViewModel(quote: sender as! Quote)
        }
    }
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        if let userInfo = activity.userInfo as? Dictionary<String, AnyObject> {
            if let uniqueIdentifier = userInfo[CSSearchableItemActivityIdentifier] as? String {
                if let quote = Quote.find(uniqueIdentifier, context: CoreDataStack.sharedInstance().mainContext) {
                    showDetailsForQuote(quote)
                }
            }
        }
        super.restoreUserActivityState(activity)
    }
    
    // MARK: UITableViewDelegate & DataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(QuoteTableViewCell.Identifier, forIndexPath: indexPath) as! QuoteTableViewCell
        cell.viewModel = QuoteViewModel(quote: quotes[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        showDetailsForQuote(quotes[indexPath.row])
    }
    
    private func showDetailsForQuote(quote: Quote) {
        self.performSegueWithIdentifier(SegueIdentifier.ShowQuote.rawValue, sender: quote)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
}
