//
//  Country.swift
//  YOUMAWO
//
//  Created by Admin on 29.03.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

public struct Country: Codable {
    var id: String
    var code: String
    var country: String
    
    init(_ dictionary: [String: Any]) {
        id = dictionary["id"] as? String ?? ""
        code = dictionary["code"] as? String ?? ""
        country = dictionary["country"] as? String ?? ""
    }
    
    init(id: String, code: String, country: String) {
        self.id = id
        self.code = code
        self.country = country
    }
}
