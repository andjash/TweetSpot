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

    fileprivate let accountStore: ACAccountStore
    
    override init() {
        accountStore = ACAccountStore()
        super.init()
    }
    
    func requestIOSTwitterAccouns(_ completion: @escaping ([ACAccount]) -> (), error: @escaping (NSError) -> ()) {
        
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccounts(with: accountType, options: nil) {(granted, err) in
            DispatchQueue.main.async(execute: { 
                if !granted {
                    error(NSError(domain: SocialAccountsServiceConstants.errorDomain, code: SocialAccountsServiceError.accessDenied.rawValue, userInfo: nil))
                    return
                }
                
                if err != nil {
                    error(NSError(domain: SocialAccountsServiceConstants.errorDomain,
                        code: SocialAccountsServiceError.innerError.rawValue,
                        userInfo: [SocialAccountsServiceConstants.innerErrorUserInfoKey : err!]))
                    
                }
                
                if let accounts = self.accountStore.accounts(with: accountType) as? [ACAccount] {
                    completion(accounts)
                } else {
                    completion([])
                }
            })
        }
    }
    
    func requestAccountWithId(_ accountId: String) -> ACAccount? {
        for account in accountStore.accounts {
            if (account as AnyObject).identifier == accountId {
                return account as? ACAccount
            }
        }
        
        return nil
    }

}
