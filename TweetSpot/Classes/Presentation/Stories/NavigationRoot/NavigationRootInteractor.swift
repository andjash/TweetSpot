//
//  NavigationRootNavigationRootInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

final class NavigationRootInteractor {

    final weak var output: NavigationRootPresenter!
    final weak var session: TwitterSession!
    
    final var trackingSesion = false
    
    @objc private final func sessionStateChanged() {
        trackingSesion = false
        NotificationCenter.default.removeObserver(self)
        switch session.state {
        case .opened:
            output.spotModuleRequired()
        case .closed:
            output.loginModuleRequired()
        default:
            break
        }
    }
    
    // MARK: - Input
    
    final func trackSessionToDecideNextModule() {
        switch session.state {
        case .opened:
            output.spotModuleRequired()
        case .closed:
            output.loginModuleRequired()
        default:
            trackingSesion = true
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(sessionStateChanged),
                                                   name: NSNotification.Name(rawValue: TwitterSessionConstants.stateChangedNotificaton), object: session)
            output.accountVerifyingUIRequired()
        }
    }
    
    
}

