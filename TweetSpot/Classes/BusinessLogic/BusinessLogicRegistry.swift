//
//  BusinessLogicRegistry.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation
import AYRegistry

final class BusinessLogicRegistry: AYRegistry {
    
    var coreServicesRegistry: CoreServicesRegistry!
    
    // WARNING: Move to constructor
    
    func activate() {
        register(initCall: { HomeTimelineModelImpl() as HomeTimelineModel}) { protocolRef in
            guard let component = protocolRef as? HomeTimelineModelImpl else { return }
            
            component.twitterDAO = self.resolve() as TwitterDAO
            component.timelineStorage = self.resolve() as HomeTimelineStorage
            component.session = self.resolve() as TwitterSession
        }
        
        register(initCall: { TwitterSessionImpl() as TwitterSession}) { protocolRef in
            guard let component = protocolRef as? TwitterSessionImpl else { return }
            
            component.webAuthHandler = self.resolve() as TwitterWebAuthHandler
            component.tokenStorage = self.resolve() as TwitterSessionCredentialsStorage
        }
        
        register(initCall: { TwitterDAOImpl() as TwitterDAO}) { protocolRef in
            guard let component = protocolRef as? TwitterDAOImpl else { return }
            
            component.deserializer = self.resolve() as TweetDTODeserializer
            component.workingQueue = DispatchQueue(label: "TwitterDAOImpl.queue", attributes: DispatchQueue.Attributes.concurrent)
            component.session = self.resolve() as TwitterSession
        }
        
        register(initCall: { UserDefaultsSettingsService(userDefaults: UserDefaults.standard) as SettingsService})
        register(initCall: { SafariTwitterWebAuthHandler() as TwitterWebAuthHandler})
        register(initCall: { InMemoryHomeTimelineStorage() as HomeTimelineStorage})
    }
}
