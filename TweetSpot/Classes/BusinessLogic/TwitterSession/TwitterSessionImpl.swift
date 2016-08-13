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
    
    let consumerKey = "cmHKRFTgcsFGVMFb5JKMo68Qg"
    let consumerSecret = "SW0fWVXir1DEKvo0tKxVqE3Q5piYge9WT8ien8juEzVgCgY3hr"
    
    let webAuthHandler: TwitterWebAuthHandler
    var tokenStorage: TwitterSessionCredentialsStorage? {
        didSet {
            if state != .Opened {
                restoreSessionState()
            }
        }
    }
    var state: TwitterSessionState {
        didSet {
            dispatch_async(dispatch_get_main_queue()) { 
                NSNotificationCenter.defaultCenter().postNotificationName(TwitterSessionConstants.stateChangedNotificaton, object: self)
            }
        }
    }
    var twitterApi: STTwitterAPI? {
        didSet {
            apiAccessObject = twitterApi
        }
    }
    var apiAccessObject: AnyObject?
    var oAuthAccessToken: String?
    var oAuthAccessTokenSecret: String?
    
    init(webAuthHandler: TwitterWebAuthHandler) {
        state = .Progress
        self.webAuthHandler = webAuthHandler
        super.init()
    }
    
    func openSessionWihtIOSAccount(account: ACAccount, success: () -> (), error: (NSError) -> ()) {
        
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
            self.tokenStorage?.clearStorage()
            self.tokenStorage?.storeIOSAccount(account)
            success()
        }, errorBlock: {[unowned self] (err) in
            error(self.wrapInnerError(err))
        })
    }
   
    
    func closeSession() {
        tokenStorage?.clearStorage()
        twitterApi = nil
        state = .Closed
    }
    
    func wrapInnerError(error: NSError) -> NSError {
        return NSError(domain: TwitterSessionConstants.errorDomain,
                       code: TwitterSessionError.SessionCreationInnerError.rawValue,
                       userInfo: [TwitterSessionConstants.innerErrorUserInfoKey : error])
    }
}


// MARK: Web auth flow
extension TwitterSessionImpl {
    
    func openSessionWihtLoginPassword(success: () -> (), error: (NSError) -> ()) {
        switch state {
        case .Opened, .Progress:
            log.error("Trying to open Twitter session while session is in invalid state")
            error(NSError(domain: TwitterSessionConstants.errorDomain, code: TwitterSessionError.SessionInvalidState.rawValue, userInfo: nil))
            return
        default:
            break
        }
        state = .Progress
        twitterApi = STTwitterAPI(OAuthConsumerKey: consumerKey, consumerSecret: consumerSecret)
        twitterApi?.postTokenRequest({[unowned self] (url, oauthToken) in self.proceedWithWebAuth(url, success: success, error: error) },
                                     authenticateInsteadOfAuthorize: false,
                                     forceLogin: true,
                                     screenName: nil,
                                     oauthCallback: "tssession://twitter_access_tokens/",
                                     errorBlock: { [unowned self] (err) in
                                        error(self.wrapInnerError(err))
                                     })
    }
    
    
    func proceedWithWebAuth(url: NSURL, success: () -> (), error: (NSError) -> ()) {
        self.webAuthHandler.handleWebAuthRequest(url, success: {[unowned self] (tokenVerificator) in
            self.twitterApi?.postAccessTokenRequestWithPIN(tokenVerificator, successBlock: { (token, secret, userId, userName) in
                self.oAuthAccessToken = token
                self.oAuthAccessTokenSecret = secret
                self.tokenStorage?.clearStorage()
                self.tokenStorage?.storeOAuthToken(token)
                self.tokenStorage?.storeOAuthTokenSecret(secret)
                self.state = .Opened
                success()
            }, errorBlock: {[unowned self] (err) in
                self.state = .Closed
                error(NSError(domain: TwitterSessionConstants.errorDomain, code: TwitterSessionError.WebAuthFailed.rawValue, userInfo: nil))
            })
        }) {[unowned self] (err) in
            self.state = .Closed
            error(err)
        }
    }

}

extension TwitterSessionImpl : STTwitterAPIOSProtocol {
    func twitterAPI(twitterAPI: STTwitterAPI!, accountWasInvalidated invalidatedAccount: ACAccount!) {
        log.severe("iOS account invalidated. Close session")
        state = .Closed
        tokenStorage?.clearStorage()
    }
}

// MARK: Session restoring
private extension TwitterSessionImpl {
    
    func restoreSessionState() {
        state = .Progress
        
        let verifyCallback : () -> () = {
            self.twitterApi?.verifyCredentialsWithUserSuccessBlock({ [unowned self]  (first, second) in
                self.state = .Opened
            }, errorBlock: {[unowned self]  (err) in
                self.state = .Closed
                self.twitterApi = nil
            })
        }
        
        self.tryToRestoreLocalAccount(verifyCallback) { [unowned self] in
            self.tryToRestorePasswordAccount(verifyCallback , error: { [unowned self] in
                    self.state = .Closed
            })
        }
    }
    
    func tryToRestoreLocalAccount(success: () -> (), error: () -> ()) {
        if let account = tokenStorage?.restoreIOSAccount() {
            twitterApi = STTwitterAPI.twitterAPIOSWithAccount(account, delegate: self)
            success()
        } else {
            error()
        }
    }
    
    func tryToRestorePasswordAccount(success: () -> (), error: () -> ()) {
        state = .Progress
        if let token = tokenStorage?.restoreOAuthToken(), secret = tokenStorage?.restoreOAuthTokenSecret() {
            twitterApi = STTwitterAPI(OAuthConsumerKey: consumerKey,
                                      consumerSecret: consumerSecret,
                                      oauthToken: token, oauthTokenSecret: secret)
            success()
        } else {
            error()
        }
    }
}