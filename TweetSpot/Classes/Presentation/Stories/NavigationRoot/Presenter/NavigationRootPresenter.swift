//
//  NavigationRootNavigationRootPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class NavigationRootPresenter: NSObject, NavigationRootModuleInput {

    weak var view: NavigationRootViewInput!
    var interactor: NavigationRootInteractorInput!
    var router: NavigationRootRouterInput!
    
    private var viewIsAppearedOnce = false

}


extension NavigationRootPresenter : NavigationRootViewOutput {
    func viewIsReady() {
        
    }
    
    func viewIsAppeared() {
        if !viewIsAppearedOnce {
            view.showAppLaunchAnimation({ [unowned self] in
                self.interactor.decideNextModuleToShow()
            })
            viewIsAppearedOnce = true
        }
    }
}


extension NavigationRootPresenter : NavigationRootInteractorOutput {
    
    func loginModuleRequired() {
        router.routeToLogin()
    }
    
    func timeLineModuleRequired() {
        
    }
}
