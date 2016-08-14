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
    let workingQueue: dispatch_queue_t
    var cancelationTokens: [String : STTwitterRequestProtocol] = [:]
    
    init(deserializer: TweetDTODeserializer, queue: dispatch_queue_t) {
        self.deserializer = deserializer
        self.workingQueue = queue
    }
    
    
    func getHomeTweets(maxId maxId: String?, minId: String?, count: Int, success: ([TweetDTO]) -> (), error: (NSError) -> ()) {
        if session.state != .Opened {
            error(NSError(domain: TwitterDAOConstants.errorDomain, code: TwitterDAOError.SessionIsNotOpened.rawValue, userInfo: nil))
            return
        }
        guard let twitterApi = session.apiAccessObject as? STTwitterAPI else {
            error(NSError(domain: TwitterDAOConstants.errorDomain, code: TwitterDAOError.InvalidSession.rawValue, userInfo: nil))
            return
        }
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
//            var result: [TweetDTO] = []
//            for index in 0..<10 {
//                result.append(TweetDTO(id: "\(NSDate().timeIntervalSince1970 + Double(index))",
//                                       creationDate: NSDate(),
//                                       text: "Cool concept art from an @H1Z1JustSurvive  intern. https://t.co/dFkZCVPrxN Cool concept art from an @H1Z1JustSurvive  intern. https://t.co/dFkZCVPrxN Cool concept art from an @H1Z1JustSurvive  intern. https://t.co/dFkZCVPrxN",
//                                        userName: "\(NSDate().timeIntervalSince1970 + Double(index))",
//                                        screenName: "test",
//                                        avatarUrlString: "https://pbs.twimg.com/profile_images/699969654530248704/YWXojPmW_normal.jpg"))
//            
//            }
//            
//            success(result)
//        }
//        return
        
        log.verbose("Requesting tweets: \n\tmaxId: \(maxId)\n\tminId: \(minId)\n\tcount: \(count)")
        let uuid = NSUUID().UUIDString
        let token = twitterApi.getStatusesHomeTimelineWithCount(String(count),
                                                                sinceID: minId,
                                                                maxID: maxId,
                                                                trimUser: false,
                                                                excludeReplies: true,
                                                                contributorDetails: false,
                                                                includeEntities: false,
        successBlock: { (statuses) in
            self.cancelationTokens[uuid] = nil
            log.verbose("Loaded \(statuses.count)")
            
            dispatch_async(self.workingQueue, {
                
                let tweets = self.deserializer.deserializeTweetDTOsFromObject(statuses)
                log.verbose("Parsed \(tweets?.count)")
              
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if let tweetDTOs = tweets {
                        success(tweetDTOs)
                    } else {
                        error(NSError(domain: TwitterDAOConstants.errorDomain, code: TwitterDAOError.UnableToParseServerResponse.rawValue, userInfo: nil))
                    }
                })
            })
        }) { (err) in
            log.error("Error while requestin tweets: \(err)")
            error(NSError(domain: TwitterDAOConstants.errorDomain,
                            code: TwitterDAOError.InnerError.rawValue,
                        userInfo: [TwitterDAOConstants.innerErrorUserInfoKey : err]))
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
