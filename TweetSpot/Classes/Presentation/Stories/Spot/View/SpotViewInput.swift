//
//  SpotSpotViewInput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol SpotViewInput {

    /**
        @author Andrey Yashnev
        Setup initial state of the view
    */

    func setupInitialState()
    func displayItemsAbove(items: [SpotTweetItem])
    func displayItemsBelow(items: [SpotTweetItem])
    
    func showForwardLoading(enabled enabled: Bool)
    func showBackwardLoading(enabled enabled: Bool)
}
