//
//  SettingsSettingsPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class SettingsPresenter: NSObject, SettingsModuleInput, SettingsViewOutput, SettingsInteractorOutput {

    weak var view: SettingsViewInput!
    var interactor: SettingsInteractorInput!
    var router: SettingsRouterInput!

    func viewIsReady() {

    }
}
