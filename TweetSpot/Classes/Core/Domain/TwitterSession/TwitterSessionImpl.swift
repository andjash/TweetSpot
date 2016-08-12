//
//  TwitterSessionImpl.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts
import STTwitter

class TwitterSessionImpl: NSObject, TwitterSession {
    
    var state: TwitterSessionState
    var twitterApi: STTwitterAPI?
    var oAuthAccessToken: String?
    var oAuthAccessTokenSecret: String?
    
    var pendingSuccessCallback: (() -> ())?
    var pendingErrorCallback: ((NSError?) -> ())?
    
    override init() {
        state = .Closed
        super.init()
    }
    
    func openSessionWihtIOSAccount(account: ACAccount, success: () -> (), error: (NSError?) -> ()) {
        
        switch state {
        case .Opened, .Progress:
            log.error("Trying to open Twitter session while session is in invalid state")
            error(NSError(domain: TwitterSessionConstants.errorDomain, code: TwitterSessionError.SessionInvalidState.rawValue, userInfo: nil))
            return
        default:
            break
        }
        
        state = .Progress
        twitterApi = STTwitterAPI.twitterAPIOSWithAccount(account, delegate: self)
        twitterApi?.verifyCredentialsWithUserSuccessBlock({[unowned self] (username, userID) in
            self.state = .Opened
            success()
        }, errorBlock: {[unowned self] (err) in
            error(self.wrapInnerError(err))
        })
    }
    
    func openSessionWihtLoginPassword(success: () -> (), error: (NSError?) -> ()) {
        switch state {
        case .Opened, .Progress:
            log.error("Trying to open Twitter session while session is in invalid state")
            error(NSError(domain: TwitterSessionConstants.errorDomain, code: TwitterSessionError.SessionInvalidState.rawValue, userInfo: nil))
            return
        default:
            break
        }
        state = .Progress
        twitterApi = STTwitterAPI(OAuthConsumerKey: "cmHKRFTgcsFGVMFb5JKMo68Qg", consumerSecret: "SW0fWVXir1DEKvo0tKxVqE3Q5piYge9WT8ien8juEzVgCgY3hr")
        twitterApi?.postTokenRequest({[unowned self] (url, oauthToken) in
            self.pendingSuccessCallback = success
            self.pendingErrorCallback = error
            UIApplication.sharedApplication().openURL(url)
        },
        authenticateInsteadOfAuthorize: false,
        forceLogin: true,
        screenName: nil,
        oauthCallback: "tssession://twitter_access_tokens/",
        errorBlock: { [unowned self] (err) in
            error(self.wrapInnerError(err))
        })
    }
    
    func handleWebAuthCallback(url: NSURL) {
        let params = parametersDictFromWebAuthCallback(url.query)
        
        let oToken = params["oauth_token"]
        let oVer = params["oauth_verifier"]
        
        let errCallback : () -> () = {
            self.state = .Closed
            self.pendingErrorCallback?(NSError(domain: TwitterSessionConstants.errorDomain, code: TwitterSessionError.WebAuthFailed.rawValue, userInfo: nil))
            self.pendingSuccessCallback = nil
            self.pendingErrorCallback = nil
        }
        
        guard let _ = oToken, ver = oVer else {
            errCallback()
            return
        }
        
        twitterApi?.postAccessTokenRequestWithPIN(ver, successBlock: {[unowned self] (oauthToken, oauthSecret, userId, screenName) in
            self.oAuthAccessToken = oauthToken
            self.oAuthAccessTokenSecret = oauthSecret
            self.state = .Opened
            self.pendingSuccessCallback?()
            self.pendingSuccessCallback = nil
            self.pendingErrorCallback = nil
        }, errorBlock: { (error) in
            errCallback()
        })
    }
    
    // MARK: Private
    
    private func wrapInnerError(error: NSError) -> NSError {
        return NSError(domain: TwitterSessionConstants.errorDomain,
                       code: TwitterSessionError.SessionCreationInnerError.rawValue,
                       userInfo: [TwitterSessionConstants.innerErrorUserInfoKey : error])
    }
    
    private func parametersDictFromWebAuthCallback(query: String?) -> [String : String] {
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
}


extension TwitterSessionImpl : STTwitterAPIOSProtocol {
    func twitterAPI(twitterAPI: STTwitterAPI!, accountWasInvalidated invalidatedAccount: ACAccount!) {
        print("Account invalidated")
    }
}
