//
//  SocialAccountsService.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts


@objc enum SocialAccountsServiceError : Int {
    case accessDenied
    case innerError    
}

struct SocialAccountsServiceConstants {
    static let errorDomain = "SocialAccountsService.errorDomain"
    static let innerErrorUserInfoKey = "SocialAccountsServiceConstants.innerErrorUserInfoKey"
}

@objc protocol SocialAccountsService {
    func requestIOSTwitterAccouns(_ completion: @escaping ([ACAccount]) -> (), error: @escaping (NSError) -> ())
    func requestAccountWithId(_ accountId: String) -> ACAccount?
}
