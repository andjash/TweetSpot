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
            if state != .opened {
                restoreSessionState()
            }
        }
    }
    var state: TwitterSessionState = .closed {
        didSet {
            if state == oldValue {
                return
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: TwitterSessionConstants.stateChangedNotificaton),
                                                                      object: self,
                                                                      userInfo: [TwitterSessionConstants.stateOldUserInfoKey : oldValue.rawValue,
                                                                                 TwitterSessionConstants.stateNewUserInfoKey : state.rawValue])
           
        }
    }
    var twitterApi: STTwitterAPI? {
        didSet {
            apiAccessObject = twitterApi
            twitterApi?.setTimeoutInSeconds(40)
        }
    }
    var apiAccessObject: AnyObject?
    var oAuthAccessToken: String?
    var oAuthAccessTokenSecret: String?
    
    init(webAuthHandler: TwitterWebAuthHandler) {
        self.webAuthHandler = webAuthHandler
        super.init()
    }
    
    func openSessionWihtIOSAccount(_ account: ACAccount, success: @escaping () -> (), error: @escaping (NSError) -> ()) {
        
        switch state {
        case .opened, .progress:
            log.error("Trying to open Twitter session while session is in invalid state")
            error(NSError(domain: TwitterSessionConstants.errorDomain, code: TwitterSessionError.sessionInvalidState.rawValue, userInfo: nil))
            return
        default:
            break
        }
        
        state = .progress
        twitterApi = STTwitterAPI.twitterAPIOS(with: account, delegate: self)
        twitterApi?.verifyCredentials(userSuccessBlock: { (username, userID) in
            self.state = .opened
            self.tokenStorage?.clearStorage()
            self.tokenStorage?.storeIOSAccount(account)
            success()
        }, errorBlock: { (err) in
            error(self.wrapInnerError(err))
        } as! (Error?) -> Void)
    }
   
    
    func closeSession() {
        tokenStorage?.clearStorage()
        twitterApi = nil
        state = .closed
    }
    
    func wrapInnerError(_ error: NSError) -> NSError {
        return NSError(domain: TwitterSessionConstants.errorDomain,
                       code: TwitterSessionError.sessionCreationInnerError.rawValue,
                       userInfo: [TwitterSessionConstants.innerErrorUserInfoKey : error])
    }
}


// MARK: Web auth flow
extension TwitterSessionImpl {
    
    func openSessionWihtLoginPassword(_ success: @escaping () -> (), error: @escaping (NSError) -> ()) {
        switch state {
        case .opened, .progress:
            log.error("Trying to open Twitter session while session is in invalid state")
            error(NSError(domain: TwitterSessionConstants.errorDomain, code: TwitterSessionError.sessionInvalidState.rawValue, userInfo: nil))
            return
        default:
            break
        }
        state = .progress
        twitterApi = STTwitterAPI(oAuthConsumerKey: consumerKey, consumerSecret: consumerSecret)
        twitterApi?.postTokenRequest({ (url, oauthToken) in self.proceedWithWebAuth(url!, success: success, error: error) },
                                     authenticateInsteadOfAuthorize: false,
                                     forceLogin: true,
                                     screenName: nil,
                                     oauthCallback: "tssession://twitter_access_tokens/",
                                     errorBlock: { (err) in
                                        self.state = .closed
                                        error(self.wrapInnerError(err! as NSError))
                                     })
    }
    
    
    func proceedWithWebAuth(_ url: URL, success: @escaping () -> (), error: @escaping (NSError) -> ()) {
        webAuthHandler.handleWebAuthRequest(url, success: {(tokenVerificator) in
            self.twitterApi?.postAccessTokenRequest(withPIN: tokenVerificator, successBlock: { (token, secret, userId, userName) in
                self.oAuthAccessToken = token
                self.oAuthAccessTokenSecret = secret
                self.tokenStorage?.clearStorage()
                self.tokenStorage?.storeOAuthToken(token)
                self.tokenStorage?.storeOAuthTokenSecret(secret)
                self.state = .opened
                success()
            }, errorBlock: { (err) in
                self.state = .closed
                error(NSError(domain: TwitterSessionConstants.errorDomain, code: TwitterSessionError.webAuthFailed.rawValue, userInfo: nil))
            })
        }) {(err) in
            self.state = .closed
            error(err)
        }
    }

}

extension TwitterSessionImpl : STTwitterAPIOSProtocol {
    func twitterAPI(_ twitterAPI: STTwitterAPI!, accountWasInvalidated invalidatedAccount: ACAccount!) {
        log.severe("iOS account invalidated. Close session")
        state = .closed
        tokenStorage?.clearStorage()
    }
}

// MARK: Session restoring
private extension TwitterSessionImpl {
    
    func restoreSessionState() {
        state = .progress
        
        let verifyCallback : () -> () = {
            self.twitterApi?.verifyCredentials(userSuccessBlock: { (first, second) in
                self.state = .opened
            }, errorBlock: { (err) in
                self.state = .closed
                self.twitterApi = nil
            })
        }
        
        self.tryToRestoreLocalAccount(verifyCallback) {
            self.tryToRestorePasswordAccount(verifyCallback , error: {
                    self.state = .closed
            })
        }
    }
    
    func tryToRestoreLocalAccount(_ success: () -> (), error: () -> ()) {
        if let account = tokenStorage?.restoreIOSAccount() {
            twitterApi = STTwitterAPI.twitterAPIOS(with: account, delegate: self)
            success()
        } else {
            error()
        }
    }
    
    func tryToRestorePasswordAccount(_ success: () -> (), error: () -> ()) {
        state = .progress
        if let token = tokenStorage?.restoreOAuthToken(), let secret = tokenStorage?.restoreOAuthTokenSecret() {
            twitterApi = STTwitterAPI(oAuthConsumerKey: consumerKey,
                                      consumerSecret: consumerSecret,
                                      oauthToken: token, oauthTokenSecret: secret)
            success()
        } else {
            error()
        }
    }
}
