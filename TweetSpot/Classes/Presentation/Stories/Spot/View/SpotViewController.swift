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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selected, animated: true)
        }
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
                    if cell.frame.minY >= tableView.contentOffset.y + tableView.contentInset.top {
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
        displayItemsWithoutScrolling(nil, newItemsAtBottom: nil, prevItems: allItems)
    }

    func displayItemsAbove(items: [SpotTweetItem]) {
        if items.count == 0 {
            tableView.pullToRefreshView.stopAnimating()
            return
        }
        
        let contentOffsetBefore = tableView.contentOffset
        let contentInsetBefore = tableView.contentInset
        self.tableView.pullToRefreshView.stopAnimating()
        let contentInsetAfter = tableView.contentInset
        
        tableView.layer.removeAllAnimations()
        tableView.contentInset = contentInsetBefore
        tableView.setContentOffset(contentOffsetBefore, animated: false)
        
        displayItemsWithoutScrolling(items, newItemsAtBottom: nil, prevItems: allItems)

        tableView.contentInset = contentInsetAfter
        self.tableView.infiniteScrollingView.enabled = true
    }
    
    func displayItemsBelow(items: [SpotTweetItem]) {
        tableView.infiniteScrollingView.stopAnimating()
        displayItemsWithoutScrolling(nil, newItemsAtBottom: items, prevItems: allItems)
    }
    
    
    func displayItemsWithoutScrolling(newItemsAtTop: [SpotTweetItem]?, newItemsAtBottom: [SpotTweetItem]?, prevItems: [SpotTweetItem]?) {
        let topVisibleIp = topmostVisibleIndexPath()
        var desiredOffset: CGFloat?
        if let indexPath = topVisibleIp {
            desiredOffset = tableView.cellForRowAtIndexPath(indexPath)!.frame.minY - tableView.contentOffset.y - tableView.contentInset.top
        }
        
        allItems = (newItemsAtTop ?? []) + (prevItems ?? []) + (newItemsAtBottom ?? [])
        
        tableView.reloadData()
        
        if let oldIp = topVisibleIp {
            let newIp = NSIndexPath(forRow: oldIp.row + (newItemsAtTop?.count ?? 0), inSection: 0)
            tableView.scrollToRowAtIndexPath(newIp, atScrollPosition: .Top, animated: false)
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y - desiredOffset!)
        }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        output.didSelectItem(allItems![indexPath.row])
    }
}
