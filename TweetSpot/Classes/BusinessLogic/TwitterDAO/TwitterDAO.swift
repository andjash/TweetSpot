//
//  TwitterDAO.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc enum TwitterDAOError : Int {
    case invalidSession
    case sessionIsNotOpened
    case noData
    case unableToParseServerResponse
    case innerError
}

struct TwitterDAOConstants {
    static let errorDomain = "TwitterDAOConstants.errorDomain"
    static let innerErrorUserInfoKey = "TwitterDAOConstants.innerErrorUserInfoKey"
    static let taskStartNotification = "TwitterDAOConstants.taskStartNotification"
    static let taskEndNotification = "TwitterDAOConstants.taskEndNotification"
}

@objc protocol TwitterDAO {
    func getHomeTweets(maxId: String?, minId: String?, count: Int, success: @escaping ([TweetDTO]) -> (), error: @escaping (NSError) -> ())
    
    func cancelAllRequests()
}
