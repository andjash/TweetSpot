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
            self.output.loadAboveRequested()
        }
        
        tableView.addInfiniteScrollingWithActionHandler { 
            self.output.loadBelowRequested()
        }
        tableView.infiniteScrollingView.enabled = false
        
        output.viewIsReady()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        output.viewIsAboutToAppear()
    }

    // MARK: Actions
    
    @IBAction func quitAction(sender: AnyObject?) {
        output.quitRequested()
    }
    
    @IBAction func settingsAction(sender: AnyObject?) {
        output.settingsRequested()
    }
    
    // MARK: Private
    
    private func topmostVisibleIndexPath() -> NSIndexPath? {
        if let paths = tableView.indexPathsForVisibleRows {
            for ip in paths {
                if let cell = tableView.cellForRowAtIndexPath(ip) {
                    if cell.frame.minY >= tableView.contentOffset.y {
                        return ip
                    }
                }
            }
        }
        return nil
    }
}


extension SpotViewController : SpotViewInput {
    
    func setupInitialState() {
        
    }
    
    func updateCellWithAvatars(displayRequired displayRequired: Bool) {
        if displayingAvatars == displayRequired {
            return
        }
        displayingAvatars = displayRequired
        
        let topVisibleIp = self.topmostVisibleIndexPath()
        var desiredOffset: CGFloat?
        if let indexPath = topVisibleIp {
             desiredOffset = tableView.cellForRowAtIndexPath(indexPath)!.frame.minY - tableView.contentOffset.y
            
        }
        
        tableView.reloadData()
        
        if let indexPath = topVisibleIp {
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y - desiredOffset!)
        }
    }

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
    
    func showAboveLoading(enabled enabled: Bool) {
        enabled ? tableView.pullToRefreshView.startAnimating() : tableView.pullToRefreshView.stopAnimating()
    }
    
    func showBelowLoading(enabled enabled: Bool) {
        enabled ? tableView.infiniteScrollingView.startAnimating() : tableView.infiniteScrollingView.stopAnimating()
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
