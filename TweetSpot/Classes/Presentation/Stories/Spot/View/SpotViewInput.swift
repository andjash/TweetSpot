//
//  SpotSpotViewInput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol SpotViewInput {
    
    func updateCellsWithAvatars(displayRequired: Bool)
    func displayItemsAbove(_ items: [SpotTweetItem])
    func displayItemsBelow(_ items: [SpotTweetItem])
    func showAboveLoading(enabled: Bool)
    func setInfiniteScrollingEnabled(_ enabled: Bool)
    func showMoreItemsAvailable()

}
