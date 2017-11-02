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
    
    @objc dynamic func homeTimelineModel() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(HomeTimelineModelImpl.self) {
            (definition) in
            definition.useInitializer(NSSelectorFromString("initWithTwitterDAO:")) {
                (initializer) in
                
                initializer!.injectParameter(with: self.twitterDAO())
            }
            
            definition.injectProperty("timelineStorage", with: self.homeTimelineStorage())
            definition.injectProperty("session", with: self.twitterSessionService())
            
            definition.scope = TyphoonScope.singleton
        }
    }
    
    @objc dynamic func twitterSessionService() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(TwitterSessionImpl.self) {
            (definition) in
            definition.useInitializer(NSSelectorFromString("initWithWebAuthHandler:")) {
                (initializer) in
                
                initializer!.injectParameter(with: self.twitterWebAuthHandler())
            }
            
            definition.injectProperty("tokenStorage", with: self.twitterSessionCredentialsStorage())
            definition.scope = TyphoonScope.singleton
        }
    }
    
    @objc dynamic func settingsService() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(UserDefaultsSettingsService.self) {
            (definition) in
            definition.useInitializer(NSSelectorFromString("initWithUserDefaults:")) {
                (initializer) in
                
                initializer!.injectParameter(with: UserDefaults.standard)
            }
            definition.scope = TyphoonScope.singleton
        }
    }
    
    @objc dynamic func twitterDAO() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(TwitterDAOImpl.self) {
            (definition) in
            definition.useInitializer(NSSelectorFromString("initWithDeserializer:queue:")) {
                (initializer) in
                
                initializer!.injectParameter(with: self.tweetDTODeserializer())
                initializer!.injectParameter(with: DispatchQueue(label: "TwitterDAOImpl.queue", attributes: DispatchQueue.Attributes.concurrent))
            }
                        
            definition.injectProperty("session", with: self.twitterSessionService())
            definition.scope = TyphoonScope.singleton
        }
    }
    
    @objc dynamic func twitterSessionCredentialsStorage() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(KeychainSessionCredentialsStorage.self) {
            (definition) in
            definition.useInitializer(NSSelectorFromString("initWithAccountsService:")) {
                (initializer) in
                
                initializer!.injectParameter(with: self.coreServices.socialAccountsService())
            }
            definition.scope = TyphoonScope.singleton
        }
    }
    
    @objc dynamic func twitterWebAuthHandler() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(SafariTwitterWebAuthHandler.self) {
            (definition) in
            
            definition.scope = TyphoonScope.singleton
        }
    }
    
    @objc dynamic func tweetDTODeserializer() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(TweetDTODictionaryDeserializer.self) {
            (definition) in
        }
    }
    
    @objc dynamic func homeTimelineStorage() -> AnyObject {
        return TyphoonDefinitionWrapper.withClass(InMemoryHomeTimelineStorage.self) {
            (definition) in
        }
    }
    
}

