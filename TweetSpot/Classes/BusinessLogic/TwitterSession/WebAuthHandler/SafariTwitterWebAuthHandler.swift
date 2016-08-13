//
//  SafariTwitterWebAuthHandler.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class SafariTwitterWebAuthHandler: NSObject, TwitterWebAuthHandler {
    
    var pendingSuccessCallback: ((tokenVerificator: String) -> ())?
    var pendingErrorCallback: ((NSError) -> ())?
    var handlingWebAuth = false
    
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SafariTwitterWebAuthHandler.appBecomeActive),
                                                         name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleWebAuthRequest(url: NSURL, success: (tokenVerificator: String) -> (), failed: (NSError) -> ()) {
        handlingWebAuth = true
        pendingSuccessCallback = success
        pendingErrorCallback = failed
        UIApplication.sharedApplication().openURL(url)
    }
    
    func handleWebAuthCallback(url: NSURL) -> Bool {
        if !handlingWebAuth {
            log.severe("Web auth canceled")
            return false
        }
        self.handlingWebAuth = false
        
        let params = parametersDictFromWebAuthCallback(url.query)
        
        let oToken = params["oauth_token"]
        let oVer = params["oauth_verifier"]
        
        let errCallback : () -> () = {
            self.pendingErrorCallback?(NSError(domain: TwitterSessionConstants.errorDomain, code: TwitterSessionError.WebAuthFailed.rawValue, userInfo: nil))
            self.pendingSuccessCallback = nil
            self.pendingErrorCallback = nil
            self.handlingWebAuth = false
        }
        
        guard let _ = oToken, ver = oVer else {
            errCallback()
            return false
        }
        
        pendingSuccessCallback?(tokenVerificator: ver)
        pendingSuccessCallback = nil
        pendingErrorCallback = nil
        handlingWebAuth = false
        return true
    }
    
    func parametersDictFromWebAuthCallback(query: String?) -> [String : String] {
        guard let queryString = query else {
            return [:]
        }
        
        var result : [String : String] = [:]
        for component in queryString.componentsSeparatedByString("&") {
            let pair = component.componentsSeparatedByString("=")
            
            if pair.count != 2 {
                continue
            }
            
            result[pair[0]] = pair[1]
        }
        return result
    }
    
    func appBecomeActive() {
        if handlingWebAuth {
            log.severe("App opened while web auth in progress. Discard auth flow")
            self.pendingErrorCallback?(NSError(domain: TwitterSessionConstants.errorDomain, code: TwitterSessionError.WebAuthFailed.rawValue, userInfo: nil))
            self.pendingSuccessCallback = nil
            self.pendingErrorCallback = nil
            self.handlingWebAuth = false
        }
    }

}