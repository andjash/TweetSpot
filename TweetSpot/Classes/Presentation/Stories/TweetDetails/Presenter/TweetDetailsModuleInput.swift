//
//  TweetDetailsTweetDetailsModuleInput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol TweetDetailsModuleInput {
    
    func configureWithDTO(tweetDTO: AnyObject)

}
