//
//  NavigationRootNavigationRootInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class NavigationRootInteractor: NSObject, NavigationRootInteractorInput {

    weak var output: NavigationRootInteractorOutput!
    weak var session: TwitterSession!
    
    var trackingSesion = false
  
    func trackSessionToDecideNextModule() {
        switch session.state {
        case .opened:
            output.spotModuleRequired()
        case .closed:
            output.loginModuleRequired()
        default:
            trackingSesion = true
            NotificationCenter.default.addObserver(self,
                                                             selector: #selector(NavigationRootInteractor.sessionStateChanged),
                                                             name: NSNotification.Name(rawValue: TwitterSessionConstants.stateChangedNotificaton), object: session)
            output.accountVerifyingUIRequired()
        }
    }
    
    
    @objc func sessionStateChanged() {
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
    
}

