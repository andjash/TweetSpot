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
        self.bundleId = (NSBundle.mainBundle().objectForInfoDictionaryKey(String(kCFBundleIdentifierKey)) as? String) ?? "KeychainSessionCredentialsStorage.BundleID"
        super.init()
    }
    
    let oauthTokenStoringKey = "oauthTokenStoringKey"
    let oauthTokenSecretStoringKey = "oauthTokenSecretStoringKey"
    let accountIdStoringKey = "accountIdStoringKey"
    
    func storeOAuthToken(token: String) {
        SAMKeychain.setPassword(token, forService: bundleId, account: oauthTokenStoringKey)
    }
    
    func storeOAuthTokenSecret(tokenSecret: String) {
        SAMKeychain.setPassword(tokenSecret, forService: bundleId, account: oauthTokenSecretStoringKey)

    }
    
    func storeIOSAccount(account: ACAccount) {
        SAMKeychain.setPassword(account.identifier, forService: bundleId, account: accountIdStoringKey)

    }
    
    func restoreOAuthToken() -> String? {
        if let token = SAMKeychain.passwordForService(bundleId, account: oauthTokenStoringKey) {
            return token
        }
        return nil
    }
    
    func restoreOAuthTokenSecret() -> String? {
        if let tokenSecret = SAMKeychain.passwordForService(bundleId, account: oauthTokenSecretStoringKey) {
            return tokenSecret
        }
        return nil
    }
    
    func restoreIOSAccount() -> ACAccount? {
        if let accountId = SAMKeychain.passwordForService(bundleId, account: accountIdStoringKey) {
            return accountsSvc.requestAccountWithId(accountId)
        }
        return nil
    }

    
    func clearStorage() {
        SAMKeychain.deletePasswordForService(bundleId, account: oauthTokenStoringKey)
        SAMKeychain.deletePasswordForService(bundleId, account: oauthTokenSecretStoringKey)
        SAMKeychain.deletePasswordForService(bundleId, account: accountIdStoringKey)
    }
}
