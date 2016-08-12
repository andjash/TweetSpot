//
//  ApplicationAssembly.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Typhoon
import RamblerTyphoonUtils

class ApplicationAssembly: TyphoonAssembly, RamblerInitialAssembly {
    
    weak var coreServices: CoreServicesAssembly!
    
    dynamic func appDelegate() -> AnyObject {
        return TyphoonDefinition.withClass(AppDelegate.self) {
            (definition) in
            definition.injectProperty("twitterSession", with: self.coreServices.twitterSessionService())
        }
    }
}

