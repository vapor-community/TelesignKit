//
//  AccountLifecycleEvent.swift
//  
//
//  Created by Andrew Edwards on 10/24/19.
//

import Foundation

public enum AccountLifecycleEvent: String {
    /// For the creation of a new account.
    case create
    /// For when an end user signs in to their account.
    case signIn = "sign-in"
    /// For when an end user completes a transaction within their account.
    case transact
    /// For when an update is performed, such as an update of account information or similar.
    case update
    /// For when an account is deleted.
    case delete
}
