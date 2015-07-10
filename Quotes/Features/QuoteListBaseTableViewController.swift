//
//  QuoteListTableViewController.swift
//  Quotes
//
//  Created by Tomasz Szulc on 10/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import Model
import UIKit

class QuoteListBaseTableViewController: UITableViewController {

    var quotes = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: QuoteTableViewCell.Identifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: QuoteTableViewCell.Identifier)
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(QuoteTableViewCell.Identifier, forIndexPath: indexPath) as! QuoteTableViewCell
        cell.viewModel = QuoteViewModel(quote: quotes[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
