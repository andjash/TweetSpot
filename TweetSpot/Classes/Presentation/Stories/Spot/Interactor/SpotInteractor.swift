//
//  SpotSpotInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class SpotInteractor: NSObject, SpotInteractorInput {

    weak var output: SpotInteractorOutput!
    weak var session: TwitterSession!
    weak var twitterDAO: TwitterDAO!
    
    
    func sessionCloseRequested() {
        session.closeSession()
    }
    
    func loadForwardRequested() {
        twitterDAO.getHomeTweets(maxId: nil, minId: nil, count: 20, success: { (dtos) in
            log.debug("SUCCESS")
        }) { (err) in
            log.debug("ERROR: \(err)")
        }
    }

}
