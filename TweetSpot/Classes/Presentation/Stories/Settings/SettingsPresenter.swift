//
//  SettingsSettingsPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

final class SettingsPresenter {
  
    final weak var view: SettingsViewController!
    final var interactor: SettingsInteractor!
    final var router: SettingsRouter!
    
    // MARK: - Interactor output
    
    final func needToUpdateWithSections(_ sections: [SettingsSection]) {
        view.show(sections)
    }
    
    // MARK: - View output
    
    final func viewIsReady() {
        interactor.requestSettingsSections()
    }
    
    final func selectedItem(_ item: SettingsItem) {
        interactor.changeRequestForItem(item)
    }
    
    final func closeRequested() {
        router.closeModule()
    }
   
}
