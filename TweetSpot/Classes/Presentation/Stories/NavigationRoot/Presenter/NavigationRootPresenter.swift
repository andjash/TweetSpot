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
    
    fileprivate var viewIsAppearedOnce = false
    fileprivate var verifyinaccountShown = false
    
}

// MARK: NavigationRootViewOutput protocol
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

// MARK: NavigationRootInteractorOutput protocol
extension NavigationRootPresenter : NavigationRootInteractorOutput {
    
    func loginModuleRequired() {
        if verifyinaccountShown {
            let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
               self.router.routeToLogin()
            }
        } else {
            router.routeToLogin()
        }
    }
    
    func spotModuleRequired() {
        if verifyinaccountShown {
            let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
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
