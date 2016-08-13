//
//  HomeTimelineStorage.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation


@objc protocol HomeTimelineStorage {
    func storeItemsAbove(items: [TweetDTO])
    func storeItemsBelow(items: [TweetDTO])
    
    func restore(completion: ([TweetDTO]) -> ())
    func clearAll()
}
