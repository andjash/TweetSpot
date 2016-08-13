//
//  HomeTimelineModel.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc enum HomeTimelineModelLoadingDirection : Int {
    case None = 0
    case Forward
    case Backward
    case Both
}

struct HomeTimelineModelConstants {
    static let timeLineChangedNotification = "HomeTimelineModelConstants.timeLineChangedNotification"
    
    static let loadingDirectionChangedNotification = "HomeTimelineModelConstants.loadingDirectionChangedNotification"
    static let loadingDirectionChangedOldDirectionUserInfoKey = "HomeTimelineModelConstants.loadingDirectionChangedOldDirectionUserInfoKey"
    static let loadingDirectionChangedNewDirectionUserInfoKey = "HomeTimelineModelConstants.loadingDirectionChangedNewDirectionUserInfoKey"
}

@objc protocol HomeTimelineModel {
    var homeLineTweets: [TweetDTO] { get }
    var loadingDirection: HomeTimelineModelLoadingDirection { get }
    
    func loadForward(success: (([TweetDTO]) -> ())?, error: ((NSError) -> ())?)
    func loadBackward(success: (([TweetDTO]) -> ())?, error: ((NSError) -> ())?)    
}
