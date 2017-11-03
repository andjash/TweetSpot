//
//  LoginLoginInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts

final class LoginInteractor: NSObject {

    final weak var output: LoginPresenter!
    final weak var socAccountsService: SocialAccountsService!
    final weak var twitterSession: TwitterSession!
    final var accounts: [ACAccount]?
    
    // MARK: - Input
    
    final func loginWithIOSAccountRequested() {
        socAccountsService.requestIOSTwitterAccouns({ (accounts) in
            self.accounts = accounts
            self.output.chooseFromLocalAccountsWithNames(accounts.map({$0.username}))            
        }) {(error) in
            self.output.loginFailed(error)
        }
    }
    
    final func loginWithPasswordRequested() {
        twitterSession.openSessionWihtLoginPassword({
            self.output.loginSuccess()
        }, error: { (error) in
            self.output.loginFailed(error)
        })
    }
    
    final func loginWithChoosenAccount(_ username: String) {
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
