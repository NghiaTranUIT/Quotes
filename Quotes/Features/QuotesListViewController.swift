//
//  ViewController.swift
//  Quotes
//
//  Created by Tomasz Szulc on 08/07/15.
//  Copyright © 2015 Tomasz Szulc. All rights reserved.
//

import UIKit

class QuotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!
    
    private var quotes = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        debug_populateQuotes()
    }
    
    private func debug_populateQuotes() {
        let q1 = Quote(content:"Life is about making an impact, not making an income.", author:"Kevin Kruse")
        let q2 = Quote(content: "Whatever the mind of man can conceive and believe, it can achieve.", author: "Napoleon Hill")
        let q3 = Quote(content: "Two roads diverged in a wood, and I—I took the one less traveled by, And that has made all the difference.", author: "Robert Frost")
        let q4 = Quote(content: "I attribute my success to this: I never gave or took any excuse.", author: "Florence Nightingale")
        let q5 = Quote(content: "You miss 100% of the shots you don’t take.", author: "Wayne Gretzky")
        let q6 = Quote(content: "I’ve missed more than 9000 shots in my career. I’ve lost almost 300 games. 26 times I’ve been trusted to take the game winning shot and missed. I’ve failed over and over and over again in my life. And that is why I succeed.", author: "Michael Jordan")
        quotes = [q1, q2, q3, q4, q5, q6]
    }
    
    // MARK: UITableViewDelegate & DataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(QuoteTableViewCell.Identifier, forIndexPath: indexPath) as! QuoteTableViewCell
        cell.viewModel = QuoteTableViewCellViewModel(quote: quotes[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
}

