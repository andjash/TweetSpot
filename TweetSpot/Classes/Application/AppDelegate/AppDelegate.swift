//
//  AppDelegate.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit
import AYRegistry

let log = Logger()

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let twitterSessionWebAuthHandler: TwitterWebAuthHandler =  (ModulesRegistry.shared.resolve() as BusinessLogicRegistry).resolve()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AYRegistry.enable()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if url.scheme == "tssession" {
            return twitterSessionWebAuthHandler.handleWebAuthCallback?(url) ?? false
        }        
        return false
    }
}


class Logger {
    
    func verbose(_ str: String) {
        print(str)
    }
    
    func error(_ str: String) {
        print(str)
    }
    
    func severe(_ str: String) {
        print(str)
    }
    
    func debug(_ str: String) {
        print(str)
    }
    
}
