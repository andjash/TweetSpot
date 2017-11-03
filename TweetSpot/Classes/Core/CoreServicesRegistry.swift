//
//  CoreServicesRegistry.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation
import AYRegistry

class CoreServicesRegistry: AYRegistry {
    
    override init() {
        super.init()
        register(initCall: { SocialAccountsServiceImpl() as SocialAccountsService })
        register(initCall: { ImagesServiceImpl() as ImagesService })
    }
}
