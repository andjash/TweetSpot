//
//  LoginLoginInteractorOutput.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

@objc protocol LoginInteractorOutput {
    
    func loginSuccess()
    func loginFailed(error: NSError)
    func chooseFromLocalAccountsWithNames(names: [String])
    
}
