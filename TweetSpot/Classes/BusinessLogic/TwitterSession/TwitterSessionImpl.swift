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

final class TwitterSessionImpl: NSObject, TwitterSession {
    
    final var webAuthHandler: TwitterWebAuthHandler!
    
    final let consumerKey = "divRrYoRFOpqecu2KD5P5p3NU"
    final let consumerSecret = "gAEBVsG0gvru05zPYzM3EhQhGwVeh73lyvXdbUX2kUqyc1nrBJ"
    
    final var tokenStorage: TwitterSessionCredentialsStorage? {
        didSet {
            if state != .opened {
                restoreSessionState()
            }
        }
    }
    
    final var state: TwitterSessionState = .closed {
        didSet {
            if state == oldValue {
                return
            }
            NotificationCenter.default.post(name: TwitterSessionConstants.stateChangedNotificaton,
                                            object: self,
                                            userInfo: [TwitterSessionConstants.stateOldUserInfoKey : oldValue.rawValue,
                                                       TwitterSessionConstants.stateNewUserInfoKey : state.rawValue])
        }
    }
    
    final var twitterApi: STTwitterAPI? {
        didSet {
            apiAccessObject = twitterApi
            twitterApi?.setTimeoutInSeconds(40)
        }
    }
    
    final var apiAccessObject: AnyObject?
    final var oAuthAccessToken: String?
    final var oAuthAccessTokenSecret: String?
 
    final func openSession(with account: ACAccount, success: @escaping () -> (), error: @escaping (TwitterSessionError) -> ()) {
        switch state {
        case .opened, .progress:
            log.error("Trying to open Twitter session while session is in invalid state")
            error(TwitterSessionError.sessionInvalidState)
            return
        default:
            break
        }
        
        state = .progress
        twitterApi = STTwitterAPI.twitterAPIOS(with: account, delegate: self)
        twitterApi?.verifyCredentials(userSuccessBlock: { username, userID in
            self.state = .opened
            self.tokenStorage?.clearStorage()
            self.tokenStorage?.store(IOSAccount: account)
            success()
        }, errorBlock: { err in
            guard let actualError = err else {
                error(TwitterSessionError.unknown)
                return
            }
            error(TwitterSessionError.innerError(actualError))
        })
    }
    
    final func closeSession() {
        tokenStorage?.clearStorage()
        twitterApi = nil
        state = .closed
    }
    
    // MARK: - Private
    
    private final func wrapInnerError(_ error: NSError) -> TwitterSessionError {
        return TwitterSessionError.innerError(error)
    }
}


// MARK: Web auth flow
extension TwitterSessionImpl {
    
    func openSessionWihtLoginPassword(_ success: @escaping () -> (), error: @escaping (TwitterSessionError) -> ()) {
        switch state {
        case .opened, .progress:
            log.error("Trying to open Twitter session while session is in invalid state")
            error(TwitterSessionError.sessionInvalidState)
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
    
    
    func proceedWithWebAuth(_ url: URL, success: @escaping () -> (), error: @escaping (TwitterSessionError) -> ()) {
        webAuthHandler.handleWebAuthRequest(url, success: {(tokenVerificator) in
            self.twitterApi?.postAccessTokenRequest(withPIN: tokenVerificator, successBlock: { (token, secret, userId, userName) in
                self.oAuthAccessToken = token
                self.oAuthAccessTokenSecret = secret
                self.tokenStorage?.clearStorage()
                self.tokenStorage?.store(OAuthToken: token)
                self.tokenStorage?.store(OAuthTokenSecret: secret)
                self.state = .opened
                success()
            }, errorBlock: { (err) in
                self.state = .closed
                error(TwitterSessionError.webAuthFailed)
            })
        }) {(err) in
            self.state = .closed
            error(TwitterSessionError.webAuthFailed)
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
        
        tryToRestoreLocalAccount(verifyCallback) {
            self.tryToRestorePasswordAccount(verifyCallback) {
                    self.state = .closed
            }
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
