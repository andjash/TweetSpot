//
//  TwitterWebAuthHandler.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol TwitterWebAuthHandler {
    func handleWebAuthRequest(url: NSURL, success: (tokenVerificator: String) -> (), failed: (NSError) -> ())
    func handleWebAuthCallback(url: NSURL) -> Bool
}