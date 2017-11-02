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
    
    @nonobjc public func useInitializer(_ selector: String, handler: @escaping (TyphoonMethod) -> Void) {
        self.useInitializer(selector) { handler($0) }
    }
    @nonobjc public func injectMethod(_ selector: String, handler: @escaping (TyphoonMethod) -> Void) {
        self.injectMethod(selector) { handler($0) }
    }
    @nonobjc public func injectProperty(_ sel: String) {
        self.injectProperty(NSSelectorFromString(sel))
    }
    @nonobjc public func injectProperty(_ selector: String, with: AnyObject!) {
        self.injectProperty(NSSelectorFromString(selector), with: with)
    }
    
}
