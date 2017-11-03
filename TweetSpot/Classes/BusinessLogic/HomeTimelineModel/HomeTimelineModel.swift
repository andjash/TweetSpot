//
//  HomeTimelineModel.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

enum HomeTimelineModelLoadingDirection: Int {
    case none
    case forward
    case backward
    case both
}

struct HomeTimelineModelConstants {    
    static let loadingDirectionChangedNotification = "HomeTimelineModelConstants.loadingDirectionChangedNotification"
    static let loadingDirectionChangedOldDirectionUserInfoKey = "HomeTimelineModelConstants.loadingDirectionChangedOldDirectionUserInfoKey"
    static let loadingDirectionChangedNewDirectionUserInfoKey = "HomeTimelineModelConstants.loadingDirectionChangedNewDirectionUserInfoKey"
}

protocol HomeTimelineModel: class {
    var homeLineTweets: [TweetDTO] { get }
    var loadingDirection: HomeTimelineModelLoadingDirection { get }
    
    func loadForward(_ success: (([TweetDTO]) -> ())?, error: ((Error) -> ())?)
    func loadBackward(_ success: (([TweetDTO]) -> ())?, error: ((Error) -> ())?)
}
