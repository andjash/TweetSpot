//
//  AppDelegate.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit
import RamblerTyphoonUtils

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
    
    func initialAssemblies() -> [AnyObject] {
        let collector = RamblerInitialAssemblyCollector()
        return collector.collectInitialAssemblyClasses()
    }
    
}

