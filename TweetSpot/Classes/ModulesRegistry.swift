//
//  ModulesRegistry.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation
import AYRegistry

final class ModulesRegistry: AYRegistry {
    
    static let shared = ModulesRegistry()
    
    final func activate() {
        register(initCall: { CoreServicesRegistry() })
        register(initCall: { BusinessLogicRegistry() }) { component in
            component.coreServicesRegistry = self.resolve() as CoreServicesRegistry
            component.activate()
        }
        register(initCall: { ApplicationRegistry() })
    }
}

