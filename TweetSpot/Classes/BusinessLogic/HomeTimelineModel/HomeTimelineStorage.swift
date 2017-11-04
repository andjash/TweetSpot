//
//  InMemoryHomeTimelineStorage.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

protocol HomeTimelineStorage: class {
    func storeItemsAbove(_ items: [TweetDTO])
    func storeItemsBelow(_ items: [TweetDTO])
    
    func restore(_ completion: ([TweetDTO]) -> ())
    func clearAll()
}

final class InMemoryHomeTimelineStorage: HomeTimelineStorage {
    
    private final var allItems: [TweetDTO] = []
    
    // MARK: - HomeTimelineStorage
    
    final func storeItemsAbove(_ items: [TweetDTO]) {
        allItems = items + allItems
    }
    
    final func storeItemsBelow(_ items: [TweetDTO]) {
        allItems += items
    }
    
    final func restore(_ completion: ([TweetDTO]) -> ()) {
        completion(allItems)
    }
    
    final func clearAll() {
        allItems.removeAll()
    }

}
