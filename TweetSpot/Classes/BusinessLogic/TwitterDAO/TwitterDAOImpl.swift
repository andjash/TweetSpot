//
//  TwitterDAOImpl.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import STTwitter

class TwitterDAOImpl: NSObject, TwitterDAO {
    
    weak var session: TwitterSession!
    let deserializer: TweetDTODeserializer
    let workingQueue: DispatchQueue
    var cancelationTokens: [String : STTwitterRequestProtocol] = [:]
    
    init(deserializer: TweetDTODeserializer, queue: DispatchQueue) {
        self.deserializer = deserializer
        self.workingQueue = queue
    }
    
    
    func getHomeTweets(maxId: String?, minId: String?, count: Int, success: @escaping ([TweetDTO]) -> (), error: @escaping (NSError) -> ()) {
        if session.state != .opened {
            error(NSError(domain: TwitterDAOConstants.errorDomain, code: TwitterDAOError.sessionIsNotOpened.rawValue, userInfo: nil))
            return
        }
        guard let twitterApi = session.apiAccessObject as? STTwitterAPI else {
            error(NSError(domain: TwitterDAOConstants.errorDomain, code: TwitterDAOError.invalidSession.rawValue, userInfo: nil))
            return
        }
        
        log.verbose("Requesting tweets: \n\tmaxId: \(String(describing: maxId))\n\tminId: \(String(describing: minId))\n\tcount: \(count)")
        let uuid = UUID().uuidString
        let token = twitterApi.getStatusesHomeTimeline(withCount: String(count),
                                                                sinceID: minId,
                                                                maxID: maxId,
                                                                trimUser: false,
                                                                excludeReplies: true,
                                                                contributorDetails: false,
                                                                includeEntities: false, useExtendedTweetMode: false,
        successBlock: { (statuses) in
            self.cancelationTokens[uuid] = nil
            guard let statuses = statuses else {
                error(NSError(domain: TwitterDAOConstants.errorDomain, code: TwitterDAOError.noData.rawValue, userInfo: nil))
                return
            }
            
            log.verbose("Loaded \(statuses.count)")
            
            self.workingQueue.async(execute: {
                
                let tweets = self.deserializer.deserializeTweetDTOsFromObject(statuses as AnyObject)
                log.verbose("Parsed \(String(describing: tweets?.count))")
                
                DispatchQueue.main.async {
                    if let tweetDTOs = tweets {
                        success(tweetDTOs)
                    } else {
                        error(NSError(domain: TwitterDAOConstants.errorDomain, code: TwitterDAOError.unableToParseServerResponse.rawValue, userInfo: nil))
                    }
                }
            })
        }) { (err) in
            log.error("Error while requestin tweets: \(String(describing: err))")
            error(NSError(domain: TwitterDAOConstants.errorDomain,
                            code: TwitterDAOError.innerError.rawValue,
                        userInfo: [TwitterDAOConstants.innerErrorUserInfoKey : err!]))
        }
        cancelationTokens[uuid] = token
    }
    
    func cancelAllRequests() {
        for (_, token) in cancelationTokens {
            token.cancel()
        }
        cancelationTokens.removeAll()
    }
}
