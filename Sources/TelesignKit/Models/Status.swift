//
//  Status.swift
//  
//
//  Created by Andrew Edwards on 10/22/19.
//

import Foundation

public struct Status: TelesignModel {
    /// This code describes the status of your transaction. You can use this code to programmatically respond. You are returned two types of codes, either status codes or error codes.
    var code: Int
    /// A text description of the status code.
    var description: String
    /// This is a timestamp showing when your transaction status was updated last.
    var updatedOn: Date?
}
