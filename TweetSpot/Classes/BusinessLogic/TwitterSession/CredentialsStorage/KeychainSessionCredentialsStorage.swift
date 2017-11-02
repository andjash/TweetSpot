//
//  KeychainSessionCredentialsStorage.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import SAMKeychain
import Accounts

class KeychainSessionCredentialsStorage: NSObject, TwitterSessionCredentialsStorage {
    
    let accountsSvc: SocialAccountsService
    let bundleId : String
    
    init(accountsService: SocialAccountsService) {
        self.accountsSvc = accountsService
        self.bundleId = (Bundle.main.object(forInfoDictionaryKey: String(kCFBundleIdentifierKey)) as? String) ?? "KeychainSessionCredentialsStorage.BundleID"
        super.init()
    }
    
    let oauthTokenStoringKey = "oauthTokenStoringKey"
    let oauthTokenSecretStoringKey = "oauthTokenSecretStoringKey"
    let accountIdStoringKey = "accountIdStoringKey"
    
    func storeOAuthToken(_ token: String?) {
        if let token = token {
            SAMKeychain.setPassword(token, forService: bundleId, account: oauthTokenStoringKey)
        } else {
            SAMKeychain.deletePassword(forService: bundleId, account: oauthTokenStoringKey)
        }
    }
    
    func storeOAuthTokenSecret(_ tokenSecret: String?) {
        if let tokenSecret = tokenSecret {
            SAMKeychain.setPassword(tokenSecret, forService: bundleId, account: oauthTokenSecretStoringKey)
        } else {
            SAMKeychain.deletePassword(forService: bundleId, account: oauthTokenSecretStoringKey)
        }
    }
    
    func storeIOSAccount(_ account: ACAccount) {
        SAMKeychain.setPassword(account.identifier as String!, forService: bundleId, account: accountIdStoringKey)

    }
    
    func restoreOAuthToken() -> String? {
        if let token = SAMKeychain.password(forService: bundleId, account: oauthTokenStoringKey) {
            return token
        }
        return nil
    }
    
    func restoreOAuthTokenSecret() -> String? {
        if let tokenSecret = SAMKeychain.password(forService: bundleId, account: oauthTokenSecretStoringKey) {
            return tokenSecret
        }
        return nil
    }
    
    func restoreIOSAccount() -> ACAccount? {
        if let accountId = SAMKeychain.password(forService: bundleId, account: accountIdStoringKey) {
            return accountsSvc.requestAccountWithId(accountId)
        }
        return nil
    }

    
    func clearStorage() {
        SAMKeychain.deletePassword(forService: bundleId, account: oauthTokenStoringKey)
        SAMKeychain.deletePassword(forService: bundleId, account: oauthTokenSecretStoringKey)
        SAMKeychain.deletePassword(forService: bundleId, account: accountIdStoringKey)
    }
}
