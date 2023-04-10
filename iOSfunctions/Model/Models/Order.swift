//
//  Order.swift
//  YOUMAWO
//
//  Created by Admin on 23.10.2020.
//  Copyright © 2020 YOUMAWO. All rights reserved.
//

import Foundation

struct Order: Codable {
    var orderType: String
    var name: String
    var email: String
    var phoneNumber: String
    var frameId: String
    var colorId: Int
    var featureIds: [String]
    var comments: String
    var address: Address
    var customization: Customization
  
    init() {
        self.orderType = "CUSTOMLIGHT"
        self.name = ""
        self.email = ""
        self.phoneNumber = ""
        self.frameId = ""
        self.colorId = 0
        self.featureIds = [""]
        self.comments = ""
        self.address = Address()
        self.customization = Customization()
    }
    
    init(orderType: String,
         name: String,
         email: String,
         phoneNumber: String,
         frameId: String,
         colorId: Int,
         featureIds: [String],
         comments: String,
         address: Address,
         customization: Customization) {
        self.orderType = orderType
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.frameId = frameId
        self.colorId = colorId
        self.featureIds = featureIds
        self.comments = comments
        self.address = address
        self.customization = customization
    }
}
