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
 
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDataManager.attachTo(tableView)
        tableDataManager.spotDelegate = self
        tableDataManager.delegate = self
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
}

extension SpotViewController : SpotTableDataMangerDelegate {
    func triggeredPullToRefresh() {
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
        
    }
    
    func updateCellWithAvatars(displayRequired displayRequired: Bool) {
        if displayRequired == tableDataManager.displayingAvatars {
            return
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
}
