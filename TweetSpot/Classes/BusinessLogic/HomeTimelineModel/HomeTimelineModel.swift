//
//  HomeTimelineModel.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc enum HomeTimelineModelLoadingDirection : Int {
    case none = 0
    case forward
    case backward
    case both
}

struct HomeTimelineModelConstants {    
    static let loadingDirectionChangedNotification = "HomeTimelineModelConstants.loadingDirectionChangedNotification"
    static let loadingDirectionChangedOldDirectionUserInfoKey = "HomeTimelineModelConstants.loadingDirectionChangedOldDirectionUserInfoKey"
    static let loadingDirectionChangedNewDirectionUserInfoKey = "HomeTimelineModelConstants.loadingDirectionChangedNewDirectionUserInfoKey"
}

@objc protocol HomeTimelineModel {
    var homeLineTweets: [TweetDTO] { get }
    var loadingDirection: HomeTimelineModelLoadingDirection { get }
    
    func loadForward(_ success: (([TweetDTO]) -> ())?, error: ((NSError) -> ())?)
    func loadBackward(_ success: (([TweetDTO]) -> ())?, error: ((NSError) -> ())?)    
}
