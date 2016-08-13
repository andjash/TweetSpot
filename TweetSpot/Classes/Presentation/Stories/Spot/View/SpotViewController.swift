//
//  SpotSpotViewController.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit
import SVPullToRefresh

class SpotViewController: UIViewController {

    var output: SpotViewOutput!
    
    @IBOutlet weak var tableView: UITableView!
    
    var allItems: [SpotTweetItem]?
    var displayingAvatars = true

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        tableView.ts_configurePullToRefresh {
            self.output.loadAboveRequsted()
        }
        
        tableView.addInfiniteScrollingWithActionHandler { 
            self.output.loadBelowRequested()
        }
        tableView.infiniteScrollingView.enabled = false
        
        output.viewIsReady()
    }


    // MARK: SpotViewInput
    func setupInitialState() {
    }
    
    // MARK: Action
    
    @IBAction func quitAction(sender: AnyObject?) {
        output.quitRequested()
    }
    
    @IBAction func settingsAction(sender: AnyObject?) {
        output.settingsRequested()
    }

}


extension SpotViewController : SpotViewInput {

    func displayItemsAbove(items: [SpotTweetItem]) {
        self.tableView.pullToRefreshView.stopAnimating()
        var indexPaths : [NSIndexPath] = []
        for index in 0..<items.count {
            indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
        }
        allItems = items + (allItems ?? [])
        if items.count > 0 {
            self.tableView.infiniteScrollingView.enabled = true
        }
        
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Top)
    }
    
    func displayItemsBelow(items: [SpotTweetItem]) {
        self.tableView.infiniteScrollingView.stopAnimating()
        var indexPaths : [NSIndexPath] = []
        let existingItemsCount = allItems?.count ?? 0
        
        for index in existingItemsCount..<(existingItemsCount + items.count) {
            indexPaths.append(NSIndexPath(forRow: index, inSection: 0))
        }
        allItems = (allItems ?? []) + items
        if items.count == 0 {
            self.tableView.infiniteScrollingView.enabled = false
        }

        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Bottom)
    }
    
    func showForwardLoading(enabled enabled: Bool) {
        
    }
    
    func showBackwardLoading(enabled enabled: Bool) {
        
    }
}

extension SpotViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SpotTweetItemCell") as! SpotTweetItemCell
        cell.bindItem(allItems![indexPath.row], displayAvatar: displayingAvatars)
        return cell
    }
}

extension SpotViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SpotTweetItemCell.cellHeight(withItem: allItems![indexPath.row], displayingAvatar: displayingAvatars, tableWidth: tableView.frame.width)
    }
}
