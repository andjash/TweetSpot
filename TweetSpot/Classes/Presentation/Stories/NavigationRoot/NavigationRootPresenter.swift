//
//  NavigationRootNavigationRootPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class NavigationRootPresenter: NSObject {

    weak var view: NavigationRootViewController!
    var interactor: NavigationRootInteractor!
    var router: NavigationRootRouter!
    
    private var viewIsAppearedOnce = false
    private var verifyinaccountShown = false
    
    
    // MARK: - View output
    
    final func viewIsAppeared() {
        if !viewIsAppearedOnce {
            view.showAppLaunchAnimation({
                self.interactor.trackSessionToDecideNextModule()
            })
            viewIsAppearedOnce = true
        } else {
            interactor.trackSessionToDecideNextModule()
        }
    }
    
    // MARK: - Interactor output
    
    final func loginModuleRequired() {
        if verifyinaccountShown {
            let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.router.routeToLogin()
            }
        } else {
            router.routeToLogin()
        }
    }
    
    final func spotModuleRequired() {
        if verifyinaccountShown {
            let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.router.routeToSpot()
            }
        } else {
            router.routeToSpot()
        }
    }
    
    final func accountVerifyingUIRequired() {
        verifyinaccountShown = true
        view.showAccountVerifyingUI()
    }
    
}
