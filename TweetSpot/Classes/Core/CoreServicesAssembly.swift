//
//  CoreServicesAssembly.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Typhoon
import RamblerTyphoonUtils

class CoreServicesAssembly: TyphoonAssembly, RamblerInitialAssembly {
    
    dynamic func socialAccountsService() -> AnyObject {
        return TyphoonDefinition.withClass(SocialAccountsServiceImpl.self) {
            (definition) in
            
            definition.scope = TyphoonScope.Singleton
        }
    }
    
}

