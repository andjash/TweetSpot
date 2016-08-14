//
//  SettingsSettingsInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class SettingsInteractor: NSObject, SettingsInteractorInput {
    
    enum SettingId : Int {
        case ShowSpotAvatars = 0
    }
    
    let settingsSvc: SettignsService
    
    weak var output: SettingsInteractorOutput!
    var sections: [SettingsSection]
    
    init(settingsSvc: SettignsService) {
        self.settingsSvc = settingsSvc
        let section1 = SettingsSection(name: "settings_spot_section_title".ts_localized("Settings"), items:
            [SwitchSettingsItem(id: SettingId.ShowSpotAvatars.rawValue, name: "settings_spot_show_avatars".ts_localized("Settings"),
                                                                        value: settingsSvc.shouldDisplayUserAvatarsOnSpot)])
        sections = [section1]
        super.init()
    }   
    
  
    func requestSettingsSections() {
        output.needToUpdateWithSections(sections)
    }
    
    func changeRequestForItem(item: SettingsItem) {
        switch item.id {
        case 0:
            if let item = item as? SwitchSettingsItem {
                updateSwitch(forItem: item)
                settingsSvc.shouldDisplayUserAvatarsOnSpot = !item.value
            }
        default:
            break
        }
    }
    
    private func updateSwitch(forItem item: SwitchSettingsItem) {
        var possibleTargetSection: SettingsSection?
        
        outerLoop: for section in sections {
            for secItem in section.items {
                if secItem.id == item.id {
                    possibleTargetSection = section
                    break outerLoop
                }
            }
        }
        
        guard let targetSection = possibleTargetSection else {return}
        
        var newItems: [SettingsItem] = []
        for oldItem in targetSection.items {
            if oldItem.id == item.id {
                newItems.append(SwitchSettingsItem(id: item.id, name: item.name, value: !item.value))
            } else {
                newItems.append(oldItem)
            }
        }
        
        let newSection = SettingsSection(name: targetSection.name, items: newItems)
        sections[sections.indexOf(targetSection)!] = newSection
        output.needToUpdateWithSections(sections)
    }
    
}