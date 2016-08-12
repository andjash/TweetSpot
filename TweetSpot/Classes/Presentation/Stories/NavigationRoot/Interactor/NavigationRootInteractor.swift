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
        case .Opened:
            output.spotModuleRequired()
        case .Closed:
            output.loginModuleRequired()
        default:
            trackingSesion = true
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(NavigationRootInteractor.sessionStateChanged),
                                                             name: TwitterSessionConstants.stateChangedNotificaton, object: session)
            output.accountVerifyingUIRequired()
        }
    }
    
    
    func sessionStateChanged() {
        trackingSesion = false
        NSNotificationCenter.defaultCenter().removeObserver(self)
        switch session.state {
        case .Opened:
            output.spotModuleRequired()
        case .Closed:
            output.loginModuleRequired()
        default:
            break
        }
    }
    
}

