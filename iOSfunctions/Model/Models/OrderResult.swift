//
//  OrderResult.swift
//  OneOfOne
//
//  Created by Admin on 30.03.2022.
//  Copyright © 2022 YOUMAWO. All rights reserved.
//

import Foundation

public struct OrderResult: Codable {
    var id: String = ""
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
    var creationDate: Date = Date()
    var uploaded: Bool = false
    var scanUploaded: Bool = false
    var scan: Data
    var screenShot: Data
    var token: String
    var customerRef: String
    var status: OrderQueueStatus
    
    init() {
        self.id = ""
        self.orderType = "CUSTOM"
        self.name = ""
        self.email = ""
        self.phoneNumber = ""
        self.frameId = ""
        self.colorId = 0
        self.featureIds = [""]
        self.comments = ""
        self.address = Address()
        self.customization = Customization()
        self.creationDate = Date()
        self.scan = Data()
        self.screenShot = Data()
        self.token = ""
        self.customerRef = ""
        self.status = .waiting
    }
    
    init(id: String,
         orderType: String,
         name: String,
         email: String,
         phoneNumber: String,
         frameId: String,
         colorId: Int,
         featureIds: [String],
         comments: String,
         address: Address,
         customization: Customization,
         creationDate: Date = Date(),
         scan: Data = Data(),
         screenShot: Data = Data(),
         token: String,
         customerRef: String,
         status: OrderQueueStatus) {
        self.id = id
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
        self.creationDate = creationDate
        self.scan = scan
        self.screenShot = screenShot
        self.token = token
        self.customerRef = customerRef
        self.status = status
    }
}
