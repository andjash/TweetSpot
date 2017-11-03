//
//  AppDelegate.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit
import RamblerTyphoonUtils
import Typhoon

let log = Logger()

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    weak var twitterSessionWebAuthHandler: TwitterWebAuthHandler =  (ModulesRegistry.shared.resolve() as BusinessLogicRegistry).resolve()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         return true
    }
    
    func initialAssemblies() -> [AnyObject] {
        let collector = RamblerInitialAssemblyCollector()
        return collector.collectInitialAssemblyClasses()! as [AnyObject]
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



class TyphoonDefinitionWrapper {
    
    class func withClass(_ clazz: Swift.AnyClass!, configuration injections: @escaping (TyphoonDefinition) -> ()) -> AnyObject {
        return TyphoonDefinition.withClass(clazz) {
            (definition) in
            injections(definition!)
        } as AnyObject
    }

    
}
