//
//  LoginLoginInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts

class LoginInteractor: NSObject, LoginInteractorInput {

    weak var output: LoginInteractorOutput!
    weak var socAccountsService: SocialAccountsService!
    weak var twitterSession: TwitterSession!
    var accounts: [ACAccount]?
    
    func loginWithIOSAccountRequested() {
        
        socAccountsService.requestIOSTwitterAccouns({ (accounts) in
            self.accounts = accounts
            self.output.chooseFromLocalAccountsWithNames(accounts.map({$0.username}))            
        }) {(error) in
            self.output.loginFailed(error)
        }
        
        
    }
    
    func loginWithPasswordRequested() {
        twitterSession.openSessionWihtLoginPassword({
            self.output.loginSuccess()
        }, error: { (error) in
            self.output.loginFailed(error)
        })
    }
    
    func loginWithChoosenAccount(username: String) {
        guard let accs = accounts else { return }
        for acc in accs {
            if acc.username == username {
                self.twitterSession.openSessionWihtIOSAccount(acc, success: {
                    self.output.loginSuccess()
                }, error: { (error) in
                    self.output.loginFailed(error)
                })
                return
            }
        }
    }
}