//
//  UserDefaultsSettingsService.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation


class UserDefaultsSettingsService: NSObject {
    
    private struct Keys {
        static let shouldDisplayUserAvatarsOnSpot = "shouldDisplayUserAvatarsOnSpot"
    }
    

    let userDefaults: NSUserDefaults
    
    init(userDefaults: NSUserDefaults) {
        self.userDefaults = userDefaults
        super.init()
    }
    
    var shouldDisplayUserAvatarsOnSpot: Bool {
        get {
            return self.userDefaults.boolForKey(Keys.shouldDisplayUserAvatarsOnSpot)
        }
        set {
            self.userDefaults.setBool(newValue, forKey: Keys.shouldDisplayUserAvatarsOnSpot)
        }
    }
    
    
    
}
