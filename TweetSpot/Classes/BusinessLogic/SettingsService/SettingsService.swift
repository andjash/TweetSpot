//
//  SettingsService.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

protocol SettingsService: class {
    var shouldDisplayUserAvatarsOnSpot: Bool { get set }
}

final class UserDefaultsSettingsService: SettingsService {
    
    private struct Keys {
        static let shouldDisplayUserAvatarsOnSpot = "shouldDisplayUserAvatarsOnSpot"
    }
    
    private final let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        if userDefaults.object(forKey: Keys.shouldDisplayUserAvatarsOnSpot) == nil {
            self.userDefaults.set(true, forKey: Keys.shouldDisplayUserAvatarsOnSpot)
        }
    }
    
    // MARK: - SettingsService
    
    final var shouldDisplayUserAvatarsOnSpot: Bool {
        get {
            return userDefaults.bool(forKey: Keys.shouldDisplayUserAvatarsOnSpot)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.shouldDisplayUserAvatarsOnSpot)
            userDefaults.synchronize()
        }
    }
    
    
    
}
