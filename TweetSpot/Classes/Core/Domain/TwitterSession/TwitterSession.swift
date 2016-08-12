//
//  TwitterSession.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts

@objc enum TwitterSessionState : Int {
    case Closed
    case Progress
    case Opened
}

@objc enum TwitterSessionError : Int {
    case SessionInvalidState
    case SessionCreationInnerError
    case WebAuthFailed    
}

struct TwitterSessionConstants {
    static let errorDomain = "TwitterSessionConstants.errorDomain"
    static let innerErrorUserInfoKey = "TwitterSessionConstants.innerErrorUserInfoKey"
    static let stateChangedNotificaton = "TwitterSessionConstants.stateChangedNotificaton"    
}


@objc protocol TwitterSession {
    
    var state: TwitterSessionState { get }
    
    func openSessionWihtIOSAccount(account: ACAccount, success: () -> (), error: (NSError) -> ())
    func openSessionWihtLoginPassword(success: () -> (), error: (NSError) -> ())
    func closeSession()
    
    func handleWebAuthCallback(url: NSURL)
}
