//
//  TwitterDAOImpl.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import STTwitter

final class TwitterDAOImpl: TwitterDAO {
    
    final weak var session: TwitterSession!
    final var deserializer: TweetDTODeserializer!
    final var workingQueue: DispatchQueue!
    
    final var cancelationTokens: [String : STTwitterRequestProtocol] = [:]
    
    final func getHomeTweets(maxId: String?, minId: String?, count: Int, success: @escaping ([TweetDTO]) -> (), error: @escaping (TwitterDAOError) -> ()) {
        guard session.state == .opened else {
            error(TwitterDAOError.sessionIsNotOpened)
            return
        }
        guard let twitterApi = session.apiAccessObject as? STTwitterAPI else {
            error(TwitterDAOError.invalidSession)
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
        successBlock: { statuses in
            self.cancelationTokens[uuid] = nil
            guard let statuses = statuses else {
                error(TwitterDAOError.noData)
                return
            }
            
            log.verbose("Loaded \(statuses.count)")
            
            self.workingQueue.async {
                
                let tweets = self.deserializer.deserializeTweetDTOs(from: statuses)
                log.verbose("Parsed \(String(describing: tweets?.count))")
                
                DispatchQueue.main.async {
                    if let tweetDTOs = tweets {
                        success(tweetDTOs)
                    } else {
                        error(TwitterDAOError.unableToParseServerResponse)
                    }
                }
            }
        }) { (err) in
            log.error("Error while requestin tweets: \(String(describing: err))")
            error(TwitterDAOError.innerError(err!))
        }
        cancelationTokens[uuid] = token
    }
    
    final func cancelAllRequests() {
        cancelationTokens.forEach { $0.value.cancel() }
        cancelationTokens.removeAll()
    }
}
