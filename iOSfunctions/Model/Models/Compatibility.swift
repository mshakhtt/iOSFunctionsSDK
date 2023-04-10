//
//  Compatibility.swift
//  OneOfOne
//
//  Created by Admin on 02.11.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

struct Compatibility: Codable {
    var updateAvailable: Bool
    var updateRequired: Bool
    var updateURL: String
     
    init(_ dictionary: [String: AnyObject]?) {
        updateAvailable = dictionary?["updateAvailable"] as? Bool ?? false
        updateRequired = dictionary?["updateRequired"]  as? Bool ?? false
        updateURL = dictionary?["updateURL"] as? String ?? ""    
    }
    
    init(updateAvailable: Bool, updateRequired: Bool, updateURL: String) {
        self.updateAvailable = updateAvailable
        self.updateRequired = updateRequired
        self.updateURL = updateURL
    }
}
