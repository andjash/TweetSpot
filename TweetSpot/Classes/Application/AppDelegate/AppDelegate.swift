//
//  AppDelegate.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit
import AYRegistry

final class AppDelegate: UIResponder, UIApplicationDelegate {

    final var window: UIWindow?
    
    final let twitterSessionWebAuthHandler: TwitterWebAuthHandler =  (ModulesRegistry.shared.resolve() as BusinessLogicRegistry).resolve()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AYRegistry.enable()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if url.scheme == "tssession" {
            return twitterSessionWebAuthHandler.handleWebAuthCallback(url)
        }        
        return false
    }
}



