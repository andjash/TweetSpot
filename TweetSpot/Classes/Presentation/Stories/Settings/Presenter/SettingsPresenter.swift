//
//  SettingsSettingsPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class SettingsPresenter: NSObject, SettingsModuleInput {
  
    weak var view: SettingsViewInput!
    var interactor: SettingsInteractorInput!
    var router: SettingsRouterInput!
   
}

// MARK: SettingsInteractorOutput protocol
extension SettingsPresenter : SettingsInteractorOutput {    
    
    func needToUpdateWithSections(sections: [SettingsSection]) {
        view.showSettings(sections)
    }
    
}

// MARK: SettingsViewOutput protocol
extension SettingsPresenter : SettingsViewOutput {
    
    func viewIsReady() {
       interactor.requestSettingsSections()
    }
    
    func selectedItem(item: SettingsItem) {
        interactor.changeRequestForItem(item)
    }
    
    
    func closeRequested() {
        router.closeModule()
    }
}