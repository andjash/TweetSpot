//
//  InMemoryHomeTimelineStorage.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class InMemoryHomeTimelineStorage: NSObject, HomeTimelineStorage {
    
    var allItems: [TweetDTO] = []
    
    func storeItemsAbove(_ items: [TweetDTO]) {
        allItems = items + allItems
        
    }
    func storeItemsBelow(_ items: [TweetDTO]) {
        allItems += items
    }
    
    func restore(_ completion: ([TweetDTO]) -> ()) {
        completion(allItems)
    }
    
    func clearAll() {
        allItems.removeAll()
    }

}
