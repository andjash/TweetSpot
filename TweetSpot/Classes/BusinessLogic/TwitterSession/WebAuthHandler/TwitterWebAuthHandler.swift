//
//  TwitterWebAuthHandler.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 13/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

protocol TwitterWebAuthHandler: class {
    func handleWebAuthRequest(_ url: URL, success: @escaping (_ tokenVerificator: String) -> (), failed: @escaping (TwitterSessionError) -> ())
    func handleWebAuthCallback(_ url: URL) -> Bool
}
