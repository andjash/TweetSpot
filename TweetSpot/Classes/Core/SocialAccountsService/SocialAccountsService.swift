//
//  SocialAccountsService.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation
import Accounts

enum SocialAccountsServiceError: Error {
    case accessDenied
    case innerError(Error)
}

protocol SocialAccountsService: class {
    func requestIOSTwitterAccouns(_ completion: @escaping ([ACAccount]) -> (), error: @escaping (SocialAccountsServiceError) -> ())
    func requestAccountWithId(_ accountId: String) -> ACAccount?
}

final class SocialAccountsServiceImpl: SocialAccountsService {
    
    private final let accountStore = ACAccountStore()
    
    // MARK: - SocialAccountsService
    
    final func requestIOSTwitterAccouns(_ completion: @escaping ([ACAccount]) -> (), error: @escaping (SocialAccountsServiceError) -> ()) {
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (granted, err) in
            DispatchQueue.main.async {
                guard granted else {
                    error(SocialAccountsServiceError.accessDenied)
                    return
                }
                
                guard err == nil else {
                    error(SocialAccountsServiceError.innerError(err!))
                    return
                }
                
                if let accounts = self.accountStore.accounts(with: accountType) as? [ACAccount] {
                    completion(accounts)
                } else {
                    completion([])
                }
            }
        }
    }
    
    func requestAccountWithId(_ accountId: String) -> ACAccount? {
        for account in accountStore.accounts {
            if let acc = account as? ACAccount, (acc.identifier as String) == accountId {
                return acc
            }
        }
        return nil
    }
}