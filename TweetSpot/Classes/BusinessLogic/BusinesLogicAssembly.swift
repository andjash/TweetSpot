//
//  BusinesLogicAssembly.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Typhoon
import RamblerTyphoonUtils

class BusinesLogicAssembly: TyphoonAssembly, RamblerInitialAssembly {
    
    var coreServices: CoreServicesAssembly!
    
    dynamic func twitterSessionService() -> AnyObject {        
        return TyphoonDefinition.withClass(TwitterSessionImpl.self) {
            (definition) in
            definition.useInitializer(NSSelectorFromString("initWithWebAuthHandler:")) {
                (initializer) in
                
                initializer.injectParameterWith(self.twitterWebAuthHandler())
            }
            
            definition.injectProperty("tokenStorage", with: self.twitterSessionCredentialsStorage())
            definition.scope = TyphoonScope.Singleton
        }
    }
    
    dynamic func twitterDAO() -> AnyObject {
        return TyphoonDefinition.withClass(TwitterDAOImpl.self) {
            (definition) in
            definition.useInitializer(NSSelectorFromString("initWithDeserializer:queue:")) {
                (initializer) in
                
                initializer.injectParameterWith(self.tweetDTODeserializer())
                initializer.injectParameterWith(dispatch_queue_create("TwitterDAOImpl.queue", DISPATCH_QUEUE_CONCURRENT))
            }
                        
            definition.injectProperty("session", with: self.twitterSessionService())
            definition.scope = TyphoonScope.Singleton
        }
    }
    
    dynamic func twitterSessionCredentialsStorage() -> AnyObject {
        return TyphoonDefinition.withClass(KeychainSessionCredentialsStorage.self) {
            (definition) in
            definition.useInitializer(NSSelectorFromString("initWithAccountsService:")) {
                (initializer) in
                
                initializer.injectParameterWith(self.coreServices.socialAccountsService())
            }
            definition.scope = TyphoonScope.Singleton
        }
    }
    
    dynamic func twitterWebAuthHandler() -> AnyObject {
        return TyphoonDefinition.withClass(SafariTwitterWebAuthHandler.self) {
            (definition) in
            
            definition.scope = TyphoonScope.Singleton
        }
    }
    
    dynamic func tweetDTODeserializer() -> AnyObject {
        return TyphoonDefinition.withClass(TweetDTODictionaryDeserializer.self) {
            (definition) in
        }
    }
    
}

