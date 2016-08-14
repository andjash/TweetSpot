//
//  SettingsItem.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class SettingsSection: NSObject {
    let name: String
    let items: [SettingsItem]
    
    init(name: String, items: [SettingsItem]) {
        self.name = name
        self.items = items
    }
}

class SettingsItem : NSObject {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

class SwitchSettingsItem : SettingsItem {
    let value: Bool
    
    init(id: Int, name: String, value: Bool) {
        self.value = value
        super.init(id: id, name: name)
    }
}
