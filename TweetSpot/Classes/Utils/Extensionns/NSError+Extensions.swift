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
            return ts_socialAccountsServiceErrorUserFriendlyDescription()
        case TwitterDAOConstants.errorDomain:
            return ts_twitterDAOErrorUserFriendlyDescription()
        default:
            return "error_common_unknown".ts_localized("Errors") + ".\n\(self.localizedDescription)"
        }
        
    }
    
}

// MARK: TwitterDAO error descriptions
extension NSError {
    
    fileprivate func ts_twitterDAOErrorUserFriendlyDescription() -> String {
        switch code {
        case TwitterDAOError.invalidSession.rawValue:
            return "error_twitter_dao_invalid_session".ts_localized("Errors")
        case TwitterDAOError.sessionIsNotOpened.rawValue:
            return "error_twitter_dao_session_not_open".ts_localized("Errors")
        case TwitterDAOError.unableToParseServerResponse.rawValue:
            return "error_twitter_dao_unable_parse_response".ts_localized("Errors")
        case TwitterDAOError.innerError.rawValue:
            let innerErr = (self.userInfo[TwitterDAOConstants.innerErrorUserInfoKey] as? NSError)
            if let innerDescr = innerErr?.localizedDescription {
                return innerDescr
            } else {
                return "error_twitter_dao_inner_error".ts_localized("Errors")
            }
        default:
            return "error_twitter_dao_unknown".ts_localized("Errors")
        }
    }
    
}


// MARK: TwitterSession error descriptions
extension NSError {
    
    fileprivate func ts_twitterSessionErrorUserFriendlyDescription() -> String {
        switch code {
        case TwitterSessionError.sessionInvalidState.rawValue:
            return "error_twitter_session_invalid_state".ts_localized("Errors")
        case TwitterSessionError.webAuthFailed.rawValue:
            return "error_twitter_web_auth_failed".ts_localized("Errors")
        case TwitterSessionError.sessionCreationInnerError.rawValue:
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
    
    fileprivate func ts_socialAccountsServiceErrorUserFriendlyDescription() -> String {
        switch code {
        case SocialAccountsServiceError.accessDenied.rawValue:
            return "error_socacc_access_denied".ts_localized("Errors")
        case SocialAccountsServiceError.innerError.rawValue:
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
