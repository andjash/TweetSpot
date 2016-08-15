//
//  TyphoonDefinition+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Typhoon

extension TyphoonDefinition {
    
    @nonobjc public func useInitializer(selector: String, handler: TyphoonMethod -> Void) {
        self.useInitializer(Selector(selector)) { handler($0) }
    }
    @nonobjc public func injectMethod(selector: String, handler: TyphoonMethod -> Void) {
        self.injectMethod(Selector(selector)) { handler($0) }
    }
    @nonobjc public func injectProperty(sel: String) {
        self.injectProperty(Selector(sel))
    }
    @nonobjc public func injectProperty(selector: String, with: AnyObject!) {
        self.injectProperty(Selector(selector), with: with)
    }
    
}