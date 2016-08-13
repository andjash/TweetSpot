//
//  AppDelegate.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit
import RamblerTyphoonUtils
import XCGLogger

let log = XCGLogger.defaultInstance()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    weak var twitterSessionWebAuthHandler: TwitterWebAuthHandler!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupLoger()
        return true
    }
    
    func initialAssemblies() -> [AnyObject] {
        let collector = RamblerInitialAssemblyCollector()
        return collector.collectInitialAssemblyClasses()
    }
    
    private func setupLoger() {
        #if DEBUG
            log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        #else
            log.setup(.Severe, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        #endif
    }
    
    
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if url.scheme == "tssession" {
            return twitterSessionWebAuthHandler.handleWebAuthCallback(url)
        }        
        return false
    }
}

