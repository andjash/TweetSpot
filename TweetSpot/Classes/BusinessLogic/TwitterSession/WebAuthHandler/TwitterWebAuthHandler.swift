//
//  TwitterWebAuthHandler.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol TwitterWebAuthHandler {
    func handleWebAuthRequest(_ url: URL, success: @escaping (_ tokenVerificator: String) -> (), failed: @escaping (NSError) -> ())
    @objc optional func handleWebAuthCallback(_ url: URL) -> Bool
}
