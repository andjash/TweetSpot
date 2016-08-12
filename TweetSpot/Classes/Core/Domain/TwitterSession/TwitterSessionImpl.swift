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
import SAMKeychain

class TwitterSessionImpl: NSObject, TwitterSession {
    
    let socAccountsSvc: SocialAccountsService?
    
    var state: TwitterSessionState
    var twitterApi: STTwitterAPI?
    var oAuthAccessToken: String?
    var oAuthAccessTokenSecret: String?
    
    var pendingSuccessCallback: (() -> ())?
    var pendingErrorCallback: ((NSError?) -> ())?
    
    init(socAccountsSvc: SocialAccountsService) {
        state = .Closed
        self.socAccountsSvc = socAccountsSvc
        super.init()
        self.restoreSessionState()
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
            self.storeAccountId(account.identifier)
            
            success()
        }, errorBlock: {[unowned self] (err) in
            error(self.wrapInnerError(err))
        })
    }
   
}


// MARK: Web auth flow
extension TwitterSessionImpl {
    
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
            self.storeTokens(oauthToken, secret: oauthSecret)
            self.state = .Opened
            self.pendingSuccessCallback?()
            self.pendingSuccessCallback = nil
            self.pendingErrorCallback = nil
            }, errorBlock: { (error) in
                errCallback()
        })
    }
    
   func wrapInnerError(error: NSError) -> NSError {
        return NSError(domain: TwitterSessionConstants.errorDomain,
                       code: TwitterSessionError.SessionCreationInnerError.rawValue,
                       userInfo: [TwitterSessionConstants.innerErrorUserInfoKey : error])
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
    
}

extension TwitterSessionImpl : STTwitterAPIOSProtocol {
    func twitterAPI(twitterAPI: STTwitterAPI!, accountWasInvalidated invalidatedAccount: ACAccount!) {
        print("Account invalidated")
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
        print("\(socAccountsSvc)")
        if let accountId = self.restoreAccountId(), account = self.socAccountsSvc?.requestAccountWithId(accountId) {
            twitterApi = STTwitterAPI.twitterAPIOSWithAccount(account, delegate: self)
            success()
        } else {
            error()
        }
    }
    
    func tryToRestorePasswordAccount(success: () -> (), error: () -> ()) {
        state = .Progress
        let (token, secret) = self.restoreTokens()
        if let token = token, secret = secret {
            twitterApi = STTwitterAPI(OAuthConsumerKey: "cmHKRFTgcsFGVMFb5JKMo68Qg",
                                      consumerSecret: "SW0fWVXir1DEKvo0tKxVqE3Q5piYge9WT8ien8juEzVgCgY3hr",
                                      oauthToken: token, oauthTokenSecret: secret)
            success()
        } else {
            error()
        }
    }
}

// MARK: Tokens storing
private extension TwitterSessionImpl {
    
    var oauthStoringKey: String {
        return "TwitterSessionImplOauthTokenStoringKey"
    }
    
    var oauthSecretStoringKey: String {
        return "TwitterSessionImplOauthTokenSecretStoringKey"
    }
    
    var accountIdStoringKey: String {
        return "TwitterSessionImplAccountIdStoringKey"
    }
    
    func storeTokens(token: String, secret: String) {
        if let bundleId = NSBundle.mainBundle().objectForInfoDictionaryKey(String(kCFBundleIdentifierKey)) as? String {
            SAMKeychain.setPassword(token, forService: bundleId, account: oauthStoringKey)
            SAMKeychain.setPassword(secret, forService: bundleId, account: oauthSecretStoringKey)
        }
    }
    
    func restoreTokens() -> (String?, String?) {
        if let bundleId = NSBundle.mainBundle().objectForInfoDictionaryKey(String(kCFBundleIdentifierKey)) as? String {
            if let token = SAMKeychain.passwordForService(bundleId, account: oauthStoringKey),
                   secret = SAMKeychain.passwordForService(bundleId, account: oauthSecretStoringKey){
                return (token, secret)
            }
        }
        return (nil, nil)
    }
    
    func storeAccountId(accountId: String) {
        if let bundleId = NSBundle.mainBundle().objectForInfoDictionaryKey(String(kCFBundleIdentifierKey)) as? String {
            SAMKeychain.setPassword(accountId, forService: bundleId, account: accountIdStoringKey)
        }
    }
    
    func restoreAccountId() -> String? {
        if let bundleId = NSBundle.mainBundle().objectForInfoDictionaryKey(String(kCFBundleIdentifierKey)) as? String {
            if let accId = SAMKeychain.passwordForService(bundleId, account: accountIdStoringKey) {
                return accId
            }
        }
        return nil
    }
    
    func clearStoredTokens() {
        if let bundleId = NSBundle.mainBundle().objectForInfoDictionaryKey(String(kCFBundleIdentifierKey)) as? String {
            SAMKeychain.deletePasswordForService(bundleId, account: oauthStoringKey)
            SAMKeychain.deletePasswordForService(bundleId, account: oauthSecretStoringKey)
            SAMKeychain.deletePasswordForService(bundleId, account: accountIdStoringKey)
        }
    }
}