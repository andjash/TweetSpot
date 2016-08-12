//
//  SocialAccountsService.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts

@objc protocol SocialAccountsService {
    func requestIOSTwitterAccouns(completion: ([ACAccount]) -> (), error: (NSError?) -> ())
}