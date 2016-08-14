//
//  SpotSpotInteractorOutput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol SpotInteractorOutput {
    
    func avatarsDisplay(required required: Bool)
    
    func forwardItemsLoaded(items: [SpotTweetItem])
    func backwardItemsLoaded(items: [SpotTweetItem])
    
    func forwardProgressUpdated(enabled enabled: Bool)
    func backwardProgressUpdated(enabled enabled: Bool)
}
