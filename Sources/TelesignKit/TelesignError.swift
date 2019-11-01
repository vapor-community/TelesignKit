//
//  TelesignError.swift
//  Telesign
//
//  Created by Andrew Edwards on 7/20/17.
//
//

import Foundation

public struct TelesignError: TelesignModel, Error {
    public var status: Status
}
