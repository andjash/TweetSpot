//
//  ApplicationRegistry.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation
import AYRegistry

final class ApplicationRegistry: AYRegistry {
    
    override init() {
        super.init()
        register(initCall: { NetworkActivityIndicatorManagerImpl() as NetworkActivityIndicatorManager})
    }
}

