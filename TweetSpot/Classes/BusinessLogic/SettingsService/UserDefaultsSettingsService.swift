//
//  UserDefaultsSettingsService.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation


class UserDefaultsSettingsService: NSObject, SettingsService {
    
    fileprivate struct Keys {
        static let shouldDisplayUserAvatarsOnSpot = "shouldDisplayUserAvatarsOnSpot"
    }
    

    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        if userDefaults.object(forKey: Keys.shouldDisplayUserAvatarsOnSpot) == nil {
            self.userDefaults.set(true, forKey: Keys.shouldDisplayUserAvatarsOnSpot)
        }
       
        super.init()
    }
    
    var shouldDisplayUserAvatarsOnSpot: Bool {
        get {
            return self.userDefaults.bool(forKey: Keys.shouldDisplayUserAvatarsOnSpot)
        }
        set {
            self.userDefaults.set(newValue, forKey: Keys.shouldDisplayUserAvatarsOnSpot)
            self.userDefaults.synchronize()
        }
    }
    
    
    
}
