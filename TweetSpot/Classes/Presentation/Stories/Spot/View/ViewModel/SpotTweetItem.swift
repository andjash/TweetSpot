//
//  SpotTweetItem.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class SpotTweetItem: NSObject {
    let id: String
    let formattedPostDate: String
    let text: String
    let userName: String
    let screenName: String
    
    var avatar: UIImage?
    var avatarRetrievedCallback: (() -> ())?
    
    init(id: String, formattedPostDate: String, text: String, userName: String, screenName: String) {
        self.id = id
        self.formattedPostDate = formattedPostDate
        self.text = text
        self.userName = userName
        self.screenName = screenName
    }
}
