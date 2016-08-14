//
//  SpotSpotInteractorOutput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol SpotInteractorOutput {
    
    func dtoFoundForItem(item: SpotTweetItem, dto: AnyObject?)
    func avatarsDisplay(required required: Bool)
    
    func forwardItemsLoaded(items: [SpotTweetItem])
    func backwardItemsLoaded(items: [SpotTweetItem])
    
}
