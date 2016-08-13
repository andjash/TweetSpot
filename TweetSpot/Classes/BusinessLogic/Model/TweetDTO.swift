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
    let creationDateStr: String
    let text: String
    let userName: String
    let avatarUrlStr: String
    
    init(id: String, creationDateSting: String, text: String, userName: String, avatarUrlString: String) {
        self.id = id
        self.creationDateStr = creationDateSting
        self.text = text
        self.userName = userName
        self.avatarUrlStr = avatarUrlString
    }
    
    override var hashValue: Int {
        return id.hash
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if self === object {
            return true
        }
        
        if let other = object as? TweetDTO {
            return self.id == other.id
        }
        return false
    }
}
