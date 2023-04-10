//
//  Address.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 05.03.2023.
//

import Foundation

public struct Address: Codable {
    var line1: String
    var line2: String
    var city: String
    var country: String
    var name: String
    var postal: String
    
    init() {
        self.line1 = ""
        self.line2 = ""
        self.city = ""
        self.country = ""
        self.name = ""
        self.postal = ""
    }
    
    init(line1: String, line2: String, city: String, country: String, name: String, postal: String) {
        self.line1 = line1
        self.line2 = line2
        self.city = city
        self.country = country
        self.name = name
        self.postal = postal
    }
}
