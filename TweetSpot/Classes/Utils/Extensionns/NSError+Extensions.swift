//
//  NSError+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 12/08/16.
//  Copyright © 2016 Andrey Yashnev. All rights reserved.
//

import Foundation


extension NSError {
    
    var ts_userFriendlyDescription: String {
        switch self.domain {
        case TwitterSessionConstants.errorDomain:
            return ts_twitterSessionErrorUserFriendlyDescription()
        case SocialAccountsServiceConstants.errorDomain:
            return pf_socialAccountsServiceErrorUserFriendlyDescription()
        default:
            return "error_common_unknown".ts_localized("Errors") + ".\n\(self.localizedDescription)"
        }
        
    }
    
}


// MARK: TwitterSession error descriptions
extension NSError {
    private func ts_twitterSessionErrorUserFriendlyDescription() -> String {
        switch self.code {
        case TwitterSessionError.SessionInvalidState.rawValue:
            return "error_twitter_session_invalid_state".ts_localized("Errors")
        case TwitterSessionError.WebAuthFailed.rawValue:
            return "error_twitter_web_auth_failed".ts_localized("Errors")
        case TwitterSessionError.SessionCreationInnerError.rawValue:
            let innerErr = (self.userInfo[TwitterSessionConstants.innerErrorUserInfoKey] as? NSError)
            if let innerDescr = innerErr?.localizedDescription {
                return innerDescr
            } else {
                return "error_twitter_session_creation_inner_error".ts_localized("Errors")
            }
        default:
            return "error_twitter_unknown".ts_localized("Errors")
        }
    }
}


// MARK: SocialAccountsService error descriptions
extension NSError {
    private func pf_socialAccountsServiceErrorUserFriendlyDescription() -> String {
        switch self.code {
        case SocialAccountsServiceError.AccessDenied.rawValue:
            return "error_socacc_access_denied".ts_localized("Errors")
        case SocialAccountsServiceError.InnerError.rawValue:
            let innerErr = (self.userInfo[SocialAccountsServiceConstants.innerErrorUserInfoKey] as? NSError)            
            if let innerDescr = innerErr?.localizedDescription {
                return innerDescr
            } else {
                return "error_socacc_inner_error".ts_localized("Errors")
            }
        default:
            return "error_socacc_unknown_error".ts_localized("Errors")
        }
    }
}
