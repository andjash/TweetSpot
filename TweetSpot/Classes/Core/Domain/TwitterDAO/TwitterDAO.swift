//
//  TwitterDAO.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc enum TwitterDAOError : Int {
    case InvalidSession
    case SessionIsNotOpened
    case UnableToParseServerResponse
    case InnerError
}

struct TwitterDAOConstants {
    static let errorDomain = "TwitterDAOConstants.errorDomain"
    static let innerErrorUserInfoKey = "TwitterDAOConstants.innerErrorUserInfoKey"
    static let taskStartNotification = "TwitterDAOConstants.taskStartNotification"
    static let taskEndNotification = "TwitterDAOConstants.taskEndNotification"
}

@objc protocol TwitterDAO {
    func getHomeTweets(maxId maxId: String?, minId: String?, count: Int, success: ([TweetDTO]) -> (), error: (NSError) -> ())
}

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
}
