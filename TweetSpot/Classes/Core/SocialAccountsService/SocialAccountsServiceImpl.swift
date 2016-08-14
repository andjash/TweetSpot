//
//  SocialAccountsServiceImpl.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts

class SocialAccountsServiceImpl: NSObject, SocialAccountsService {

    private let accountStore: ACAccountStore
    
    override init() {
        accountStore = ACAccountStore()
        super.init()
    }
    
    func requestIOSTwitterAccouns(completion: ([ACAccount]) -> (), error: (NSError) -> ()) {
        
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) {(granted, err) in
            dispatch_async(dispatch_get_main_queue(), { 
                if !granted {
                    error(NSError(domain: SocialAccountsServiceConstants.errorDomain, code: SocialAccountsServiceError.AccessDenied.rawValue, userInfo: nil))
                    return
                }
                
                if err != nil {
                    error(NSError(domain: SocialAccountsServiceConstants.errorDomain,
                        code: SocialAccountsServiceError.InnerError.rawValue,
                        userInfo: [SocialAccountsServiceConstants.innerErrorUserInfoKey : err]))
                    
                }
                
                if let accounts = self.accountStore.accountsWithAccountType(accountType) as? [ACAccount] {
                    completion(accounts)
                } else {
                    completion([])
                }
            })
        }
    }
    
    func requestAccountWithId(accountId: String) -> ACAccount? {
        for account in accountStore.accounts {
            if account.identifier == accountId {
                return account as? ACAccount
            }
        }
        
        return nil
    }

}
