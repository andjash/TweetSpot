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
    func storeOAuthToken(_ token: String?)
    func storeOAuthTokenSecret(_ tokenSecret: String?)
    func storeIOSAccount(_ account: ACAccount)
    
    func restoreOAuthToken() -> String?
    func restoreOAuthTokenSecret() -> String?
    func restoreIOSAccount() -> ACAccount?
    
    func clearStorage()
}
