//
//  TwitterSessionCredentialsStorage.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts

protocol TwitterSessionCredentialsStorage: class {
    func store(OAuthToken token: String?)
    func store(OAuthTokenSecret tokenSecret: String?)
    func store(IOSAccount account: ACAccount)
    
    func restoreOAuthToken() -> String?
    func restoreOAuthTokenSecret() -> String?
    func restoreIOSAccount() -> ACAccount?
    
    func clearStorage()
}
