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
        homeTimelineModel.loadForward({ (dtos) in
            var result: [SpotTweetItem] = []
            for dto in dtos {
                let item = SpotTweetItem(formattedPostDate: dto.creationDateStr,
                    text: dto.text,
                    userName: dto.userName,
                    screenName: "@todo",
                    avatar: nil)
                result.append(item)
            }
            self.output.forwardItemsLoaded(result)
        }) { (error) in
            log.debug("Error while loading backward")
        }
    }
    
    func loadBackwardRequested() {
        homeTimelineModel.loadBackward({ (dtos) in
            var result: [SpotTweetItem] = []
            for dto in dtos {
                let item = SpotTweetItem(formattedPostDate: dto.creationDateStr,
                    text: dto.text,
                    userName: dto.userName,
                    screenName: "@todo",
                    avatar: nil)
                result.append(item)
            }
            self.output.backwardItemsLoaded(result)            
        }) { (error) in
            log.debug("Error while loading backward")
        }
    }

}
