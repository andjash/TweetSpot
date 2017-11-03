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

final class KeychainSessionCredentialsStorage: TwitterSessionCredentialsStorage {
    
    final var accountsSvc: SocialAccountsService!
    final let bundleId : String
    
    override init() {
        self.bundleId = (Bundle.main.object(forInfoDictionaryKey: String(kCFBundleIdentifierKey)) as? String) ?? "KeychainSessionCredentialsStorage.BundleID"
        super.init()
    }
    
    final let oauthTokenStoringKey = "oauthTokenStoringKey"
    final let oauthTokenSecretStoringKey = "oauthTokenSecretStoringKey"
    final let accountIdStoringKey = "accountIdStoringKey"
    
    final func store(OAuthToken token: String?) {
        if let token = token {
            SAMKeychain.setPassword(token, forService: bundleId, account: oauthTokenStoringKey)
        } else {
            SAMKeychain.deletePassword(forService: bundleId, account: oauthTokenStoringKey)
        }
    }
    
    final func store(OAuthTokenSecret tokenSecret: String?) {
        if let tokenSecret = tokenSecret {
            SAMKeychain.setPassword(tokenSecret, forService: bundleId, account: oauthTokenSecretStoringKey)
        } else {
            SAMKeychain.deletePassword(forService: bundleId, account: oauthTokenSecretStoringKey)
        }
    }
    
    final func store(IOSAccount account: ACAccount) {
        SAMKeychain.setPassword(account.identifier as String!, forService: bundleId, account: accountIdStoringKey)

    }
    
    final func restoreOAuthToken() -> String? {
        if let token = SAMKeychain.password(forService: bundleId, account: oauthTokenStoringKey) {
            return token
        }
        return nil
    }
    
    final func restoreOAuthTokenSecret() -> String? {
        if let tokenSecret = SAMKeychain.password(forService: bundleId, account: oauthTokenSecretStoringKey) {
            return tokenSecret
        }
        return nil
    }
    
    final func restoreIOSAccount() -> ACAccount? {
        if let accountId = SAMKeychain.password(forService: bundleId, account: accountIdStoringKey) {
            return accountsSvc.requestAccountWithId(accountId)
        }
        return nil
    }

    
    final func clearStorage() {
        SAMKeychain.deletePassword(forService: bundleId, account: oauthTokenStoringKey)
        SAMKeychain.deletePassword(forService: bundleId, account: oauthTokenSecretStoringKey)
        SAMKeychain.deletePassword(forService: bundleId, account: accountIdStoringKey)
    }
}
