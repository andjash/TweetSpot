//
//  TwitterSession.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts

enum TwitterSessionState : Int {
    case closed
    case progress
    case opened
}

enum TwitterSessionError : Error {
    case sessionInvalidState
    case webAuthFailed
    case unknown
    case innerError(Error)
}

struct TwitterSessionConstants {
    static let stateChangedNotificaton = Notification.Name("TwitterSessionConstants.stateChangedNotificaton")
    static let stateOldUserInfoKey = "TwitterSessionConstants.stateOldUserInfoKey"
    static let stateNewUserInfoKey = "TwitterSessionConstants.stateNewUserInfoKey"
}


protocol TwitterSession: class {
    var state: TwitterSessionState { get }
    var apiAccessObject: AnyObject? { get }
    
    func openSession(with account: ACAccount, success: @escaping () -> (), error: @escaping (TwitterSessionError) -> ())
    func openSessionWihtLoginPassword(_ success: @escaping () -> (), error: @escaping (TwitterSessionError) -> ())
    func closeSession()
}
