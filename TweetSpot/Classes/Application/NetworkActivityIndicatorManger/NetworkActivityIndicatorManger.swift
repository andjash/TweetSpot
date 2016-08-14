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
    
    private var networkActivityIndicationCount =  0
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(NetworkActivityIndicatorManagerImpl.sessionStateChanged),
                                                         name: TwitterSessionConstants.stateChangedNotificaton, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(NetworkActivityIndicatorManagerImpl.timelineModelStateChanged),
                                                         name: HomeTimelineModelConstants.loadingDirectionChangedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(NetworkActivityIndicatorManagerImpl.increaseNetworkActivityIndication),
                                                         name: ImagesServiceConstants.didStartRetreivingImageNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(NetworkActivityIndicatorManagerImpl.decreaseNetworkActivityIndication),
                                                         name: ImagesServiceConstants.didEndRetreivingImageNotification, object: nil)     
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func increaseNetworkActivityIndication() {
        dispatch_async(dispatch_get_main_queue()) {
            self.networkActivityIndicationCount += 1
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), object: nil)
            self.performSelector(#selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), withObject: nil, afterDelay: 0)
        }
    }
    
    func decreaseNetworkActivityIndication() {
        dispatch_async(dispatch_get_main_queue()) {
            self.networkActivityIndicationCount -= 1
            if self.networkActivityIndicationCount < 0 {
                self.networkActivityIndicationCount = 0
            }
            NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), object: nil)
            self.performSelector(#selector(NetworkActivityIndicatorManagerImpl.updateNetworkActivityIndicator), withObject: nil, afterDelay: 0.3)
        }
        
    }
    
    func updateNetworkActivityIndicator() {
        dispatch_async(dispatch_get_main_queue()) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = self.networkActivityIndicationCount > 0
        }
    }
    
    
    func sessionStateChanged(notification: NSNotification) {
        if let new = notification.userInfo?[TwitterSessionConstants.stateNewUserInfoKey] as? Int,
               old = notification.userInfo?[TwitterSessionConstants.stateOldUserInfoKey] as? Int  {
            if new == TwitterSessionState.Progress.rawValue {
                increaseNetworkActivityIndication()
            } else if old == TwitterSessionState.Progress.rawValue {
                decreaseNetworkActivityIndication()
            }
        }
    }
    
    func timelineModelStateChanged(notification: NSNotification) {
        if let new = notification.userInfo?[HomeTimelineModelConstants.loadingDirectionChangedNewDirectionUserInfoKey] as? Int,
               old = notification.userInfo?[HomeTimelineModelConstants.loadingDirectionChangedOldDirectionUserInfoKey] as? Int  {
            if new == HomeTimelineModelLoadingDirection.None.rawValue {
                decreaseNetworkActivityIndication()
            } else if old == HomeTimelineModelLoadingDirection.None.rawValue {
                increaseNetworkActivityIndication()
            }
        }
    }
}