//
//  TweetDTO.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class TweetDTO : NSObject {
    let id: String
    let creationDate: Date
    let text: String
    let userName: String
    let screenName: String
    let avatarUrlStr: String
    
    init(id: String, creationDate: Date, text: String, userName: String, screenName: String, avatarUrlString: String) {
        self.id = id
        self.creationDate = creationDate
        self.text = text
        self.userName = userName
        self.screenName = screenName
        self.avatarUrlStr = avatarUrlString
    }
    
    override var hashValue: Int {
        return id.hash
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? TweetDTO else { return false }
        
        if self === object {
            return true
        }
  
        return id == object.id
    }
}
