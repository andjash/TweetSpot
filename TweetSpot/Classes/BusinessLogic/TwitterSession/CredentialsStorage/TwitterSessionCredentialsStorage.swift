//
//  TwitterSessionCredentialsStorage.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts

@objc protocol TwitterSessionCredentialsStorage {
    func storeOAuthToken(token: String)
    func storeOAuthTokenSecret(tokenSecret: String)
    func storeIOSAccount(account: ACAccount)
    
    func restoreOAuthToken() -> String?
    func restoreOAuthTokenSecret() -> String?
    func restoreIOSAccount() -> ACAccount?
    
    func clearStorage()
}
