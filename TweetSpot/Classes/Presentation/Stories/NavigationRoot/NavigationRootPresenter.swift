//
//  NavigationRootNavigationRootPresenter.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

final class NavigationRootPresenter {

    final weak var view: NavigationRootViewController!
    final var interactor: NavigationRootInteractor!
    final var router: NavigationRootRouter!
    
    private final var viewIsAppearedOnce = false
    private final var verifyinaccountShown = false
    
    
    // MARK: - View output
    
    final func viewIsAppeared() {
        if !viewIsAppearedOnce {
            view.showAppLaunchAnimation {
                self.interactor.trackSessionToDecideNextModule()
            }
            viewIsAppearedOnce = true
        } else {
            interactor.trackSessionToDecideNextModule()
        }
    }
    
    // MARK: - Interactor output
    
    final func loginModuleRequired() {
        if verifyinaccountShown {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.router.routeToLogin()
            }
        } else {
            router.routeToLogin()
        }
    }
    
    final func spotModuleRequired() {
        if verifyinaccountShown {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
