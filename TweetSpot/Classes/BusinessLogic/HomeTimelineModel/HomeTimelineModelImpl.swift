//
//  HomeTimelineModelImpl.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class HomeTimelineModelImpl: NSObject, HomeTimelineModel {
    
    weak var session: TwitterSession?
    
    let twitterDAO: TwitterDAO
    var timelineStorage: HomeTimelineStorage? {
        didSet {
            loadingDirection = .both
            timelineStorage?.restore({[weak self] (dtos) in
                guard let sself = self else { return }
                sself.homeLineTweets = dtos
                sself.loadingDirection = .none
            })
        }
    }
    
    init(twitterDAO: TwitterDAO) {
        self.twitterDAO = twitterDAO
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTimelineModelImpl.sessionStateChanged),
                                                         name: NSNotification.Name(rawValue: TwitterSessionConstants.stateChangedNotificaton), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var homeLineTweets: [TweetDTO] = []     
    var loadingDirection: HomeTimelineModelLoadingDirection = .none {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: HomeTimelineModelConstants.loadingDirectionChangedNotification),
                                                                      object: self,
                                                                      userInfo: [HomeTimelineModelConstants.loadingDirectionChangedOldDirectionUserInfoKey : oldValue.rawValue,
                                                                                 HomeTimelineModelConstants.loadingDirectionChangedNewDirectionUserInfoKey : loadingDirection.rawValue])
        }
    }
    
    func loadForward(_ success: (([TweetDTO]) -> ())?, error: ((NSError) -> ())?) {
        if !proceedWithLoadingDirection(.forward) {
            return
        }
        let count = homeLineTweets.count > 0 ? 200 : 20
        twitterDAO.getHomeTweets(maxId: nil, minId: homeLineTweets.first?.id, count: count, success: {[weak self] (dtos) in
            guard let strongSelf = self else { return }
            if strongSelf.session?.state != .opened { return }
            
            strongSelf.completeWithLoadingDirection(.forward)
            var resultDtos = dtos
            if dtos.count > 0 {
                if (dtos.last == strongSelf.homeLineTweets.last) {
                    if dtos.count > 1 {
                       resultDtos = Array(dtos[0...dtos.count - 2])
                    } else {
                        resultDtos = []
                    }
                    //TODO: there are more tweets on server, load them
                }
                strongSelf.timelineStorage?.storeItemsAbove(dtos)
                strongSelf.homeLineTweets = resultDtos + strongSelf.homeLineTweets
            }
            success?(dtos)
        }) {[weak self]  (err) in
            guard let strongSelf = self else { return }
            if strongSelf.session?.state != .opened { return }
            
            strongSelf.completeWithLoadingDirection(.backward)
            error?(err)
        }
    }
    
    
    func loadBackward(_ success: (([TweetDTO]) -> ())?, error: ((NSError) -> ())?) {
        if !proceedWithLoadingDirection(.backward) {
            return
        }
    
        twitterDAO.getHomeTweets(maxId: homeLineTweets.last?.id, minId: nil, count: 20, success: {[weak self] (dtos) in
            guard let strongSelf = self else { return }
            if strongSelf.session?.state != .opened { return }
            
            strongSelf.completeWithLoadingDirection(.backward)
            var resultDtos = dtos
            if dtos.count > 0 {
                if (dtos.first == strongSelf.homeLineTweets.last) {
                    if dtos.count > 1 {
                        resultDtos = Array(dtos[1...dtos.count - 1])
                    } else {
                        resultDtos = []
                    }
                }
                strongSelf.timelineStorage?.storeItemsBelow(dtos)
                strongSelf.homeLineTweets += resultDtos
            }
            success?(resultDtos)
        }) {[weak self]  (err) in
            guard let strongSelf = self else { return }
            if strongSelf.session?.state != .opened { return }
            
            strongSelf.completeWithLoadingDirection(.backward)
            error?(err)
        }
    }
    
    @objc func sessionStateChanged() {
        if self.session?.state == .closed {
            homeLineTweets = []
            twitterDAO.cancelAllRequests()
        }
    }
    
    // MARK: Private
    
    func proceedWithLoadingDirection(_ direction: HomeTimelineModelLoadingDirection) -> Bool {
        if direction == .forward {
            switch loadingDirection {
            case .forward, .both:
                log.debug("Trying to load forward while forward loading already in progress")
                return false
            case .none:
                loadingDirection = .forward
            case .backward:
                loadingDirection = .both
            }
            return true
        } else {
            switch loadingDirection {
            case .backward, .both:
                log.debug("Trying to load backward while backward loading already in progress")
                return false
            case .none:
                loadingDirection = .backward
            case .forward:
                loadingDirection = .both
            }
            return true
        }
    }
    
    func completeWithLoadingDirection(_ direction: HomeTimelineModelLoadingDirection) {
        if direction == .forward {
            switch loadingDirection {
            case .both:
                loadingDirection = .backward
            default:
                loadingDirection = .none
            }
        } else {
            switch loadingDirection {
            case .both:
                loadingDirection = .forward
            default:
                loadingDirection = .none
            }
        }
    }
}
