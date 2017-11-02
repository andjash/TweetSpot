//
//  SettingsSettingsInteractorInput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol SettingsInteractorInput {
    
    func requestSettingsSections()
    func changeRequestForItem(_ item: SettingsItem)
    
}
