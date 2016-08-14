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
    private var verifyinaccountShown = false
    
}


extension NavigationRootPresenter : NavigationRootViewOutput {
    func viewIsReady() {
        
    }
    
    func viewIsAppeared() {
        if !viewIsAppearedOnce {
            view.showAppLaunchAnimation({
                self.interactor.trackSessionToDecideNextModule()
            })
            viewIsAppearedOnce = true
        } else {
            interactor.trackSessionToDecideNextModule()
        }
    }
}


extension NavigationRootPresenter : NavigationRootInteractorOutput {
    
    func loginModuleRequired() {
        if verifyinaccountShown {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
               self.router.routeToLogin()
            }
        } else {
            router.routeToLogin()
        }
    }
    
    func spotModuleRequired() {
        if verifyinaccountShown {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.router.routeToSpot()
            }
        } else {
            router.routeToSpot()
        }
    }
    
    func accountVerifyingUIRequired() {
        verifyinaccountShown = true
        view.showAccountVerifyingUI()
    }
}
