//
//  SafariTwitterWebAuthHandler.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import UIKit

class SafariTwitterWebAuthHandler: NSObject, TwitterWebAuthHandler {
    
    var pendingSuccessCallback: ((_ tokenVerificator: String) -> ())?
    var pendingErrorCallback: ((TwitterSessionError) -> ())?
    var handlingWebAuth = false
    
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(SafariTwitterWebAuthHandler.appBecomeActive),
                                                         name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func handleWebAuthRequest(_ url: URL, success: @escaping (_ tokenVerificator: String) -> (), failed: @escaping (TwitterSessionError) -> ()) {
        handlingWebAuth = true
        pendingSuccessCallback = success
        pendingErrorCallback = failed
        UIApplication.shared.openURL(url)
    }
    
    func handleWebAuthCallback(_ url: URL) -> Bool {
        if !handlingWebAuth {
            log.severe("Web auth canceled")
            return false
        }
        self.handlingWebAuth = false
        
        let params = parametersDictFromWebAuthCallback(url.query)
        
        let oToken = params["oauth_token"]
        let oVer = params["oauth_verifier"]
        
        let errCallback : () -> () = {
            self.pendingErrorCallback?(TwitterSessionError.webAuthFailed)
            self.pendingSuccessCallback = nil
            self.pendingErrorCallback = nil
            self.handlingWebAuth = false
        }
        
        guard let _ = oToken, let ver = oVer else {
            errCallback()
            return false
        }
        
        pendingSuccessCallback?(ver)
        pendingSuccessCallback = nil
        pendingErrorCallback = nil
        handlingWebAuth = false
        return true
    }
    
    func parametersDictFromWebAuthCallback(_ query: String?) -> [String : String] {
        guard let queryString = query else {
            return [:]
        }
        
        var result : [String : String] = [:]
        for component in queryString.components(separatedBy: "&") {
            let pair = component.components(separatedBy: "=")
            
            if pair.count != 2 {
                continue
            }
            
            result[pair[0]] = pair[1]
        }
        return result
    }
    
    @objc func appBecomeActive() {
        if handlingWebAuth {
            log.severe("App opened while web auth in progress. Discard auth flow")
            self.pendingErrorCallback?(TwitterSessionError.webAuthFailed)
            self.pendingSuccessCallback = nil
            self.pendingErrorCallback = nil
            self.handlingWebAuth = false
        }
    }

}
