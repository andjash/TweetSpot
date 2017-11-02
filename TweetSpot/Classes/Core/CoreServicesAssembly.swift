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
    
    @objc dynamic func socialAccountsService() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SocialAccountsServiceImpl.self) {
            (definition) in
            
            definition.scope = TyphoonScope.singleton
        }
    }
    
    @objc dynamic func imagesService() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(ImagesServiceImpl.self) {
            (definition) in
            
            definition.scope = TyphoonScope.singleton
        }
    }
    
}

