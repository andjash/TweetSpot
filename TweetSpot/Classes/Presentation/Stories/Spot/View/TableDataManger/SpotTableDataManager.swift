//
//  File.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

@objc protocol SpotTableDataMangerDelegate {
    func triggeredPullToRefresh()
    func triggeredInfiteScroll()
}

@objc protocol SpotTableDataManager : CommonTableDataManager {
    weak var spotDelegate: SpotTableDataMangerDelegate? {get set}
    var displayingAvatars: Bool { get set }
    var allItems: [SpotTweetItem]? { get }
    var infiniteScrollEnabled: Bool { get set }
    
    func insertItemsAtTop(items: [SpotTweetItem])
    func insertItemsAtBottom(items: [SpotTweetItem])
    
    func showPullToRefreshAnimation(enabled: Bool)
    func showInfiniteScrollAnimation(enabled: Bool)
    
    
}



class SpotTableDataManagerImpl: NSObject, SpotTableDataManager {
    
    weak var delegate: CommonTableDataManagerDelegate?
    weak var spotDelegate: SpotTableDataMangerDelegate?
    weak var tableView: UITableView!
    var infiniteScrollEnabled: Bool = false {
        didSet {
            tableView.infiniteScrollingView.enabled = infiniteScrollEnabled
            tableView.infiniteScrollingView.stopAnimating()
        }
    }
    
    var allItems: [SpotTweetItem]?
    var displayingAvatars = true
    
    func attachTo(tableView: UITableView) {
        self.tableView = tableView
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView()
        tableView.ts_configurePullToRefresh {
            self.spotDelegate?.triggeredPullToRefresh()
        }
        
        tableView.addInfiniteScrollingWithActionHandler {
            self.spotDelegate?.triggeredInfiteScroll()
        }
    }
    
    func reloadWithData(data: [AnyObject]) {
        allItems = data as? [SpotTweetItem]
        displayItemsWithoutScrolling(nil, newItemsAtBottom: nil, prevItems: allItems)
    }
    
    func insertItemsAtTop(items: [SpotTweetItem]) {
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
    }
    
    func insertItemsAtBottom(items: [SpotTweetItem]) {
        tableView.infiniteScrollingView.stopAnimating()
        displayItemsWithoutScrolling(nil, newItemsAtBottom: items, prevItems: allItems)
    }
    
    func updateCellWithAvatars(displayRequired displayRequired: Bool) {
        if displayingAvatars == displayRequired {
            return
        }
        displayingAvatars = displayRequired
        displayItemsWithoutScrolling(nil, newItemsAtBottom: nil, prevItems: allItems)
    }
    
    func showPullToRefreshAnimation(enabled: Bool) {
         enabled ? tableView.pullToRefreshView.startAnimating() : tableView.pullToRefreshView.stopAnimating()
    }
    
    func showInfiniteScrollAnimation(enabled: Bool) {
        enabled ? tableView.infiniteScrollingView.startAnimating() : tableView.infiniteScrollingView.stopAnimating()
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
    }}

extension SpotTableDataManagerImpl : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SpotTweetItemCell") as! SpotTweetItemCell
        cell.bindItem(allItems![indexPath.row], displayAvatar: displayingAvatars)
        return cell
    }
}


extension SpotTableDataManagerImpl : UITabBarDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SpotTweetItemCell.cellHeight(withItem: allItems![indexPath.row], displayingAvatar: displayingAvatars, tableWidth: tableView.frame.width)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.dataItemSelected(allItems![indexPath.row])
    }
}

