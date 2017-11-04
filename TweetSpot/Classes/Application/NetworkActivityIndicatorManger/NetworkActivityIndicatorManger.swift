//
//  NetworkActivityIndicatorManger.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

protocol NetworkActivityIndicatorManager: class {
    func increaseNetworkActivityIndication()
    func decreaseNetworkActivityIndication()
}

final class NetworkActivityIndicatorManagerImpl: NSObject, NetworkActivityIndicatorManager {
    
    private final var networkActivityIndicationCount =  0
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionStateChanged),
                                               name: TwitterSessionConstants.stateChangedNotificaton, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(timelineModelStateChanged),
                                               name: HomeTimelineModelConstants.loadingDirectionChangedNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(increaseNetworkActivityIndication),
                                               name: ImagesServiceConstants.didStartRetreivingImageNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(decreaseNetworkActivityIndication),
                                               name: ImagesServiceConstants.didEndRetreivingImageNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: NetworkActivityIndicatorManager
    
    @objc final func increaseNetworkActivityIndication() {
        DispatchQueue.main.async {
            self.networkActivityIndicationCount += 1
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), object: nil)
            self.perform(#selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), with: nil, afterDelay: 0)
        }
    }
    
    @objc final func decreaseNetworkActivityIndication() {
        DispatchQueue.main.async {
            self.networkActivityIndicationCount -= 1
            if self.networkActivityIndicationCount < 0 {
                self.networkActivityIndicationCount = 0
            }
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), object: nil)
            self.perform(#selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), with: nil, afterDelay: 0.3)
        }
        
    }
    
    // MARK: - Private
    
    @objc private final func updateNetworkActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.networkActivityIndicationCount > 0
        }
    }
    
    
    @objc private final func sessionStateChanged(_ notification: Notification) {
        if let new = notification.userInfo?[TwitterSessionConstants.stateNewUserInfoKey] as? Int,
               let old = notification.userInfo?[TwitterSessionConstants.stateOldUserInfoKey] as? Int  {
            if new == TwitterSessionState.progress.rawValue {
                increaseNetworkActivityIndication()
            } else if old == TwitterSessionState.progress.rawValue {
                decreaseNetworkActivityIndication()
            }
        }
    }
    
    @objc private final func timelineModelStateChanged(_ notification: Notification) {
        if let new = notification.userInfo?[HomeTimelineModelConstants.loadingDirectionChangedNewDirectionUserInfoKey] as? Int,
               let old = notification.userInfo?[HomeTimelineModelConstants.loadingDirectionChangedOldDirectionUserInfoKey] as? Int  {
            if HomeTimelineModelLoadingDirection(rawValue: new) == HomeTimelineModelLoadingDirection.none {
                decreaseNetworkActivityIndication()
            } else if HomeTimelineModelLoadingDirection(rawValue: old) == HomeTimelineModelLoadingDirection.none {
                increaseNetworkActivityIndication()
            }
        }
    }
}
