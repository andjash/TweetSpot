//
//  SpotSpotInteractorInput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol SpotInteractorInput {
    
    func requestIfNeedToShowAvatars()
    func sessionCloseRequested()
    func loadForwardRequested()
    func loadBackwardRequested()    

}
