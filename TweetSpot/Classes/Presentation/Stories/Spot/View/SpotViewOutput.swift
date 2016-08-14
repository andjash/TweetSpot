//
//  SpotSpotViewOutput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol SpotViewOutput {

    /**
        @author Andrey Yashnev
        Notify presenter that view is ready
    */

    func viewIsReady()
    func viewIsAboutToAppear()
    
    func quitRequested()
    func settingsRequested()
    
    func loadAboveRequested()
    func loadBelowRequested()
    
    func didSelectItem(item: SpotTweetItem)
    
}
