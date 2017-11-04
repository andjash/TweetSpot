//
//  Error+Extensions.swift
//  TweetSpot
//
//  Created by Andrey Yashnev on 03/11/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

protocol FriendlyError {
    var ts_userFriendlyDescription: String { get }
}

extension Error {
    
    var ts_uiDescription: String {
        if let userFrinedly = self as? FriendlyError {
            return userFrinedly.ts_userFriendlyDescription
        }
        return "Unknown error"
    }

}

// MARK: - TwitterDAO error descriptions

extension TwitterDAOError: FriendlyError {
    
    var ts_userFriendlyDescription: String {
        switch self {
        case .invalidSession:
            return "error_twitter_dao_invalid_session".ts_localized("Errors")
        case .sessionIsNotOpened:
            return "error_twitter_dao_session_not_open".ts_localized("Errors")
        case .unableToParseServerResponse:
            return "error_twitter_dao_unable_parse_response".ts_localized("Errors")
        case .innerError(let error):
            if let err = error as? FriendlyError {
                return err.ts_userFriendlyDescription
            }
            return error.localizedDescription
        default:
            return "error_twitter_dao_unknown".ts_localized("Errors")
        }
        
    }
    
}

// MARK: - TwitterSession error descriptions

extension TwitterSessionError: FriendlyError {
    
    var ts_userFriendlyDescription: String {
        switch self {
        case .sessionInvalidState:
            return "error_twitter_session_invalid_state".ts_localized("Errors")
        case .webAuthFailed:
            return "error_twitter_web_auth_failed".ts_localized("Errors")
        case .innerError(let error):
            if let err = error as? FriendlyError {
                return err.ts_userFriendlyDescription
            }
            return error.localizedDescription
        case .unknown:
            return "error_twitter_unknown".ts_localized("Errors")
        }
    }
}

// MARK: - SocialAccountsService error descriptions

extension SocialAccountsServiceError: FriendlyError {
    
    var ts_userFriendlyDescription: String {
        switch self {
        case .accessDenied:
            return "error_socacc_access_denied".ts_localized("Errors")
        case .innerError(let inner):
            if let err = inner as? FriendlyError {
                return err.ts_userFriendlyDescription
            }
            return inner.localizedDescription
        default:
            return "error_socacc_unknown_error".ts_localized("Errors")
        }
    }
}
