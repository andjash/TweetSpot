//
//  NetworkActivityIndicatorManger.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

@objc protocol NetworkActivityIndicatorManager {
    func increaseNetworkActivityIndication()
    func decreaseNetworkActivityIndication()
}

class NetworkActivityIndicatorManagerImpl: NSObject, NetworkActivityIndicatorManager {
    
    fileprivate var networkActivityIndicationCount =  0
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(NetworkActivityIndicatorManagerImpl.sessionStateChanged),
                                                         name: NSNotification.Name(rawValue: TwitterSessionConstants.stateChangedNotificaton), object: nil)
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(NetworkActivityIndicatorManagerImpl.timelineModelStateChanged),
                                                         name: NSNotification.Name(rawValue: HomeTimelineModelConstants.loadingDirectionChangedNotification), object: nil)
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(NetworkActivityIndicatorManagerImpl.increaseNetworkActivityIndication),
                                                         name: NSNotification.Name(rawValue: ImagesServiceConstants.didStartRetreivingImageNotification), object: nil)
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(NetworkActivityIndicatorManagerImpl.decreaseNetworkActivityIndication),
                                                         name: NSNotification.Name(rawValue: ImagesServiceConstants.didEndRetreivingImageNotification), object: nil)     
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func increaseNetworkActivityIndication() {
        DispatchQueue.main.async {
            self.networkActivityIndicationCount += 1
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), object: nil)
            self.perform(#selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), with: nil, afterDelay: 0)
        }
    }
    
    func decreaseNetworkActivityIndication() {
        DispatchQueue.main.async {
            self.networkActivityIndicationCount -= 1
            if self.networkActivityIndicationCount < 0 {
                self.networkActivityIndicationCount = 0
            }
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), object: nil)
            self.perform(#selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), with: nil, afterDelay: 0.3)
        }
        
    }
    
    @objc func updateNetworkActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = self.networkActivityIndicationCount > 0
        }
    }
    
    
    @objc func sessionStateChanged(_ notification: Notification) {
        if let new = notification.userInfo?[TwitterSessionConstants.stateNewUserInfoKey] as? Int,
               let old = notification.userInfo?[TwitterSessionConstants.stateOldUserInfoKey] as? Int  {
            if new == TwitterSessionState.progress.rawValue {
                increaseNetworkActivityIndication()
            } else if old == TwitterSessionState.progress.rawValue {
                decreaseNetworkActivityIndication()
            }
        }
    }
    
    @objc func timelineModelStateChanged(_ notification: Notification) {
        if let new = notification.userInfo?[HomeTimelineModelConstants.loadingDirectionChangedNewDirectionUserInfoKey] as? Int,
               let old = notification.userInfo?[HomeTimelineModelConstants.loadingDirectionChangedOldDirectionUserInfoKey] as? Int  {
            if new == HomeTimelineModelLoadingDirection.none.rawValue {
                decreaseNetworkActivityIndication()
            } else if old == HomeTimelineModelLoadingDirection.none.rawValue {
                increaseNetworkActivityIndication()
            }
        }
    }
}
