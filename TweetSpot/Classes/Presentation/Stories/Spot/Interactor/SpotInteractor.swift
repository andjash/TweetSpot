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
    weak var homeTimelineModel: HomeTimelineModel!
    
    
    func sessionCloseRequested() {
        session.closeSession()
    }
    
    func loadForwardRequested() {
        homeTimelineModel.loadBackward({ (dtos) in
            log.debug("Load backward success")
            for dto in self.homeTimelineModel.homeLineTweets {
                log.debug("\(dto.id) \(dto.text)")
            }
            log.debug("Total count: \(self.homeTimelineModel.homeLineTweets.count)")
        }) { (error) in
            log.debug("Error while loading backward")
        }
    }

}
