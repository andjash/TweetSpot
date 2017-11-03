//
//  LazyRegistry.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation
import AYRegistry

class LazyRegistry: AYRegistry {
    
    private var lazyregistryDone = false
    
    // Protected
    
    func initiateLazyRegistration() {
        if (lazyregistryDone) {
            return
        }
        lazyregistryDone = true
        lazyRegistration()
    }
    
    func lazyRegistration() {}
    
}
