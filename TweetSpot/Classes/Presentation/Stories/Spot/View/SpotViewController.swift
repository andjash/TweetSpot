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
    
    var tableDataManager: SpotTableDataManager!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTweetsButton: UIButton!
    @IBOutlet weak var newTweetsButtonTopSpace: NSLayoutConstraint!
    
    deinit {
        log.debug("Deinit on \(self)")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "spot_title".ts_localized("Spot")
        newTweetsButton.setTitle("spot_new_tweet_available".ts_localized("Spot"), forState: .Normal)
        newTweetsButton.layoutIfNeeded()
        newTweetsButton.backgroundColor = UIColor.ts_applicationPrimaryColor
        newTweetsButton.layer.cornerRadius = newTweetsButton.frame.height / 2
       
        newTweetsButton.layer.shadowColor = UIColor.blackColor().CGColor
        newTweetsButton.layer.shadowOffset = CGSize(width: 0, height: 5);
        newTweetsButton.layer.shadowRadius = 5;
        newTweetsButton.layer.shadowOpacity = 0.3;
        newTweetsButton.layer.shadowPath = CGPathCreateWithRoundedRect(newTweetsButton.bounds, newTweetsButton.frame.height / 2, newTweetsButton.frame.height / 2, nil)
        newTweetsButtonTopSpace.constant = -newTweetsButton.frame.height - newTweetsButton.layer.shadowOffset.height - newTweetsButton.layer.shadowRadius
        
        tableDataManager.attachTo(tableView)
        tableDataManager.spotDelegate = self
        tableDataManager.delegate = self
        output.viewIsReady()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        output.viewIsAboutToAppear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewIsAboutToDisappear()
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
    
    @IBAction func showNewTweetsAction(sender: AnyObject?) {
        UIView.animateWithDuration(0.3, animations: {
            self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self.newTweetsButtonTopSpace.constant = -self.newTweetsButton.frame.height - self.newTweetsButton.layer.shadowOffset.height - self.newTweetsButton.layer.shadowRadius
            self.view.layoutIfNeeded()
        }) { _ in
            self.tableDataManager.showPullToRefreshAnimation(true)
            self.output.showMoreItemsRequested()
        }
    }
}

extension SpotViewController : SpotTableDataMangerDelegate {
    func triggeredPullToRefresh() {
        UIView.animateWithDuration(0.3, animations: {
            self.newTweetsButtonTopSpace.constant = -self.newTweetsButton.frame.height - self.newTweetsButton.layer.shadowOffset.height - self.newTweetsButton.layer.shadowRadius
            self.view.layoutIfNeeded()
        })
        output.loadAboveRequested()
    }
    
    func triggeredInfiteScroll() {
        output.loadBelowRequested()
    }
}

extension SpotViewController : CommonTableDataManagerDelegate {
    func dataItemSelected(item: AnyObject) {
        if let tweet = item as? SpotTweetItem {
            output.didSelectItem(tweet)
        }
    }
}


extension SpotViewController : SpotViewInput {
    
    func setupInitialState() {
    }  
    
    func setInfiniteScrollingEnabled(enabled: Bool) {
        tableDataManager.infiniteScrollEnabled = enabled
    }
    
    func updateCellWithAvatars(displayRequired displayRequired: Bool) {
        if displayRequired == tableDataManager.displayingAvatars {
            return
        }
        if displayRequired {
            if let allItems = self.tableDataManager.allItems {
                output.avatarsLoadRequestedForItems(allItems)
            }
        }
        
        tableDataManager.displayingAvatars = displayRequired
        if let all = tableDataManager.allItems {
            tableDataManager.reloadWithData(all)
        }
    }
    
    func displayItemsAbove(items: [SpotTweetItem]) {
        tableDataManager.insertItemsAtTop(items)
    }
    
    func displayItemsBelow(items: [SpotTweetItem]) {
        tableDataManager.insertItemsAtBottom(items)
    }
    
    
    func showAboveLoading(enabled enabled: Bool) {
        tableDataManager.showPullToRefreshAnimation(enabled)
    }
    
    func showBelowLoading(enabled enabled: Bool) {
        tableDataManager.showInfiniteScrollAnimation(enabled)
    }
    
    func showMoreItemsAvailable() {
        UIView.animateWithDuration(0.3, animations: {
            self.newTweetsButtonTopSpace.constant = 10
            self.view.layoutIfNeeded()
        })
    }
}
