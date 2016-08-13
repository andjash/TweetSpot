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
    
    func storeItemsAbove(items: [TweetDTO]) {
        allItems = items + allItems
        
    }
    func storeItemsBelow(items: [TweetDTO]) {
        allItems += items
    }
    
    func restore(completion: ([TweetDTO]) -> ()) {
        completion(allItems)
    }
    
    func clearAll() {
        allItems.removeAll()
    }

}
