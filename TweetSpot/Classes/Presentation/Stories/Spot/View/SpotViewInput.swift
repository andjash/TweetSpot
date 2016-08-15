//
//  SpotSpotViewInput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol SpotViewInput {
    
    func updateCellsWithAvatars(displayRequired displayRequired: Bool)
    func displayItemsAbove(items: [SpotTweetItem])
    func displayItemsBelow(items: [SpotTweetItem])
    func showAboveLoading(enabled enabled: Bool)
    func setInfiniteScrollingEnabled(enabled: Bool)
    func showMoreItemsAvailable()

}
