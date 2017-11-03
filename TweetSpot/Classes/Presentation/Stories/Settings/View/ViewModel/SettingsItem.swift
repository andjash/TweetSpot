//
//  SettingsItem.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 14/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

struct SettingsSection {
    let name: String
    let items: [SettingsItem]
}

protocol SettingsItem {
    var id: Int { get }
    var name: String { get }
}

struct PlainItem: SettingsItem {
    let id: Int
    let name: String
}

struct SwitchSettingsItem: SettingsItem {
    let id: Int
    let name: String
    let value: Bool
}
