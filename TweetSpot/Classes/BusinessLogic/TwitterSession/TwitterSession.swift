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
    case closed
    case progress
    case opened
}

@objc enum TwitterSessionError : Int {
    case sessionInvalidState
    case sessionCreationInnerError
    case webAuthFailed    
}

struct TwitterSessionConstants {
    static let errorDomain = "TwitterSessionConstants.errorDomain"
    static let innerErrorUserInfoKey = "TwitterSessionConstants.innerErrorUserInfoKey"
    
    static let stateChangedNotificaton = "TwitterSessionConstants.stateChangedNotificaton"
    static let stateOldUserInfoKey = "TwitterSessionConstants.stateOldUserInfoKey"
    static let stateNewUserInfoKey = "TwitterSessionConstants.stateNewUserInfoKey"
}


@objc protocol TwitterSession {
    
    var state: TwitterSessionState { get }
    @objc optional var apiAccessObject: AnyObject? { get }
    
    func openSessionWihtIOSAccount(_ account: ACAccount, success: @escaping () -> (), error: @escaping (NSError) -> ())
    func openSessionWihtLoginPassword(_ success: @escaping () -> (), error: @escaping (NSError) -> ())
    func closeSession()
}
