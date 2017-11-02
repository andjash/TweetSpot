//
//  HomeTimelineStorage.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation


@objc protocol HomeTimelineStorage {
    func storeItemsAbove(_ items: [TweetDTO])
    func storeItemsBelow(_ items: [TweetDTO])
    
    func restore(_ completion: ([TweetDTO]) -> ())
    func clearAll()
}
