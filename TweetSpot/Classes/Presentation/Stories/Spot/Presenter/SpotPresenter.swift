//
//  SpotSpotPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class SpotPresenter: NSObject, SpotModuleInput, SpotInteractorOutput {

    weak var view: SpotViewInput!
    var interactor: SpotInteractorInput!
    var router: SpotRouterInput!

    func viewIsReady() {

    }
}


extension SpotPresenter : SpotViewOutput {
    
    func quitRequested() {
        interactor.sessionCloseRequested()
        router.closeModule()
    }
}

  