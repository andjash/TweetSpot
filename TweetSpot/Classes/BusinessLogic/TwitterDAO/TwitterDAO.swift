//
//  TwitterDAO.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

enum TwitterDAOError: Error {
    case invalidSession
    case sessionIsNotOpened
    case noData
    case unableToParseServerResponse
    case innerError(Error)
}

struct TwitterDAOConstants {
    static let errorDomain = "TwitterDAOConstants.errorDomain"
    static let innerErrorUserInfoKey = "TwitterDAOConstants.innerErrorUserInfoKey"
    static let taskStartNotification = "TwitterDAOConstants.taskStartNotification"
    static let taskEndNotification = "TwitterDAOConstants.taskEndNotification"
}

protocol TwitterDAO: class {
    func getHomeTweets(maxId: String?, minId: String?, count: Int, success: @escaping ([TweetDTO]) -> (), error: @escaping (TwitterDAOError) -> ())
    func cancelAllRequests()
}
