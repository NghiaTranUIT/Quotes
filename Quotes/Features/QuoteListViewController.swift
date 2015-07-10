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
    case AddQuote = "AddQuote"
    case ShowQuote = "ShowQuote"
}

class QuoteListViewController: QuoteListBaseTableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    private var searchController: UISearchController!
    private var resultsTableController: QuoteListBaseTableViewController!
    private var resultsUpdater = QuoteResultsUpdater()
    
    private var searchControllerWasActive = false
    private var searchControllerSearchFieldWasFirstResponder = false
    
    override var quotes: [Quote] {
        didSet {
            resultsUpdater.quotes = quotes
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
    }
    
    private func configureSearchController() {
        // Create results table controller and search controller
        resultsTableController = QuoteListBaseTableViewController()
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = resultsUpdater
        
        // set other properties
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        tableView.tableHeaderView = searchController.searchBar
        resultsTableController.tableView.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        quotes = Quote.findAll(CoreDataStack.sharedInstance().mainContext)
        startUserActivity()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // if search controller was active before, make it active
        if searchControllerWasActive {
            searchController.active = true
            searchControllerWasActive = false
        
            // if text field was active, re-activate it
            if searchControllerSearchFieldWasFirstResponder {
                searchController.searchBar.becomeFirstResponder()
                searchControllerSearchFieldWasFirstResponder = false
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        userActivity?.invalidate()
    }
    
    func startUserActivity() {
        let activity = NSUserActivity(activityType: ActivityType.QuotesList.rawValue)
        activity.title = "Viewing Quotes List"
        userActivity = activity
        userActivity?.becomeCurrent()
    }
    
    @IBAction func populateQuotes(sender: AnyObject) {
        let populatedQuotes = Quote.debugPopulate(CoreDataStack.sharedInstance().mainContext)
        quotes += populatedQuotes
        
        if #available(iOS 9.0, *) {
            Quote.index(populatedQuotes)
        }
        
        do { try CoreDataStack.sharedInstance().mainContext.save() } catch { /* do nothing */ }
        tableView.reloadData()
    }
    
    // MARK: - UITableView
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        showDetailsForQuote(quotes[indexPath.row])
    }
    
    func showDetailsForQuote(quote: Quote) {
        self.performSegueWithIdentifier(SegueIdentifier.ShowQuote.rawValue, sender: quote)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch SegueIdentifier(rawValue: segue.identifier!)! {
        case .ShowQuote:
            let quoteDetailsVC = segue.destinationViewController as! QuoteDetailsViewController
            quoteDetailsVC.viewModel = QuoteViewModel(quote: sender as! Quote)
        default: break
        }
    }

    // MARK: - Handoff
    override func restoreUserActivityState(activity: NSUserActivity) {
        if let userInfo = activity.userInfo as? Dictionary<String, AnyObject> {
            print(userInfo)
            let quoteIdentifier: String?
            if activity.activityType == CSSearchableItemActionType {
                quoteIdentifier = userInfo[CSSearchableItemActivityIdentifier] as? String
            } else {
                quoteIdentifier = userInfo["quote.identifier"] as? String
            }
            
            if let uniqueIdentifier = quoteIdentifier {
                if let quote = Quote.find(uniqueIdentifier, context: CoreDataStack.sharedInstance().mainContext) {
                    self.showDetailsForQuote(quote)
                }
            }
        }
        super.restoreUserActivityState(activity)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
