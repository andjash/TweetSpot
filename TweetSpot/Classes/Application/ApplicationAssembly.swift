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
    
    weak var businessLogicAssembly: BusinesLogicAssembly!
    
    @objc dynamic func appDelegate() -> AnyObject {
        
        return TyphoonDefinitionWrapper.withClass(AppDelegate.self) {
            (definition) in
            definition.injectProperty("twitterSessionWebAuthHandler", with: self.businessLogicAssembly.twitterWebAuthHandler())
        }
    }
    
    @objc dynamic func networkActivityIndicatorManager() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(NetworkActivityIndicatorManagerImpl.self) {
            (definition) in
            
            definition.scope = TyphoonScope.singleton
        }
    }
}

