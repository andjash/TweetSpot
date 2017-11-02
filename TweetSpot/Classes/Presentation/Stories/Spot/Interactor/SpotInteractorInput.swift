//
//  SpotSpotInteractorInput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol SpotInteractorInput {
    
    func requestIfNeedToShowAvatars() -> Bool
    func requestImagesForItems(_ items: [SpotTweetItem])
    func sessionCloseRequested()
    func loadForwardRequested()
    func loadBackwardRequested()
    func requestDTOForItem(_ item: SpotTweetItem)
    func requestCachedItems(_ completion: @escaping ([SpotTweetItem]?) -> ())
    func setPrefetchingEnabled(_ enabled: Bool)

}
