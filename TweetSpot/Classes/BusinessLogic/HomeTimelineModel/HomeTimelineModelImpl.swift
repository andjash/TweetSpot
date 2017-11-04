//
//  HomeTimelineModelImpl.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

final class HomeTimelineModelImpl: HomeTimelineModel {
    
    final weak var session: TwitterSession?
    final var twitterDAO: TwitterDAO!
    
    final var timelineStorage: HomeTimelineStorage? {
        didSet {
            loadingDirection = .both
            timelineStorage?.restore { [weak self] dtos in
                guard let `self` = self else { return }
                self.homeLineTweets = dtos
                self.loadingDirection = .none
            }
        }
    }
    
    var homeLineTweets: [TweetDTO] = []
    var loadingDirection: HomeTimelineModelLoadingDirection = .none {
        didSet {
            NotificationCenter.default.post(name: HomeTimelineModelConstants.loadingDirectionChangedNotification,
                                            object: self,
                                            userInfo: [HomeTimelineModelConstants.loadingDirectionChangedOldDirectionUserInfoKey : oldValue.rawValue,
                                                       HomeTimelineModelConstants.loadingDirectionChangedNewDirectionUserInfoKey : loadingDirection.rawValue])
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTimelineModelImpl.sessionStateChanged),
                                               name: TwitterSessionConstants.stateChangedNotificaton, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - HomeTimelineModel
    
    final func loadForward(_ success: (([TweetDTO]) -> ())?, error: ((Error) -> ())?) {
        guard proceedWithLoadingDirection(.forward) else {
            return
        }
        
        let count = homeLineTweets.count > 0 ? 200 : 20
        twitterDAO.getHomeTweets(maxId: nil, minId: homeLineTweets.first?.id, count: count, success: {[weak self] (dtos) in
            guard let `self` = self else { return }
            if self.session?.state != .opened { return }
            
            self.completeWithLoadingDirection(.forward)
            var resultDtos = dtos
            if dtos.count > 0 {
                if (dtos.last?.id == self.homeLineTweets.last?.id) {
                    if dtos.count > 1 {
                       resultDtos = Array(dtos[0...dtos.count - 2])
                    } else {
                        resultDtos = []
                    }
                    //TODO: there are more tweets on server, load them
                }
                self.timelineStorage?.storeItemsAbove(dtos)
                self.homeLineTweets = resultDtos + self.homeLineTweets
            }
            success?(dtos)
        }) { [weak self]  err in
            guard let `self` = self else { return }
            guard self.session?.state == .opened else { return }
            
            self.completeWithLoadingDirection(.backward)
            error?(err)
        }
    }
    
    
    final func loadBackward(_ success: (([TweetDTO]) -> ())?, error: ((Error) -> ())?) {
        guard proceedWithLoadingDirection(.backward) else { return }
    
        twitterDAO.getHomeTweets(maxId: homeLineTweets.last?.id, minId: nil, count: 20, success: {[weak self] (dtos) in
            guard let `self` = self else { return }
            guard self.session?.state == .opened else { return }
            
            self.completeWithLoadingDirection(.backward)
            var resultDtos = dtos
            if dtos.count > 0 {
                if dtos.first?.id == self.homeLineTweets.last?.id {
                    if dtos.count > 1 {
                        resultDtos = Array(dtos[1...dtos.count - 1])
                    } else {
                        resultDtos = []
                    }
                }
                self.timelineStorage?.storeItemsBelow(dtos)
                self.homeLineTweets += resultDtos
            }
            success?(resultDtos)
        }) { [weak self]  err in
            guard let `self` = self else { return }
            guard self.session?.state == .opened else { return }
            
            self.completeWithLoadingDirection(.backward)
            error?(err)
        }
    }
    
    // MARK: - Private
    
    @objc private final func sessionStateChanged() {
        if session?.state == .closed {
            homeLineTweets = []
            twitterDAO.cancelAllRequests()
        }
    }
    
    private final func proceedWithLoadingDirection(_ direction: HomeTimelineModelLoadingDirection) -> Bool {
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
    
    private final func completeWithLoadingDirection(_ direction: HomeTimelineModelLoadingDirection) {
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
