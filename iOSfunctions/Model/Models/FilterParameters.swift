//
//  FilterParameters.swift
//  OneOfOneFrameworkCore
//
//  Created by Shandor Baloh on 03.02.2023.
//

import Foundation

public struct FilterParameters {
    var collections = [String]()
    var frameName = ""
    var statuses = [String: Bool]()
    
    init() {}
}
