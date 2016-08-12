//
//  LoginLoginInteractor.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/2016.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation

class LoginInteractor: NSObject, LoginInteractorInput {

    weak var output: LoginInteractorOutput!
    weak var socAccountsService: SocialAccountsService!
    weak var twitterSession: TwitterSession!
    
    func loginWithIOSAccountRequested() {
        
        socAccountsService.requestIOSTwitterAccouns({[unowned self] (accounts) in
            self.twitterSession.openSessionWihtIOSAccount(accounts.first!, success: {
                print("Success")
            }, error: { (error) in
                print("Error")
            })
        }) { (error) in
            print("Error")
        }
        
        
    }
    
    func loginWithPasswordRequested() {
        twitterSession.openSessionWihtLoginPassword({
            print("Success")
        }, error: { (error) in
            print("Error")
        })
    }
}