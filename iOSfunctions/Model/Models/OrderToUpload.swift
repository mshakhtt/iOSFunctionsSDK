//
//  OrderToUpload.swift
//  OneOfOne
//
//  Created by Admin on 07.12.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

struct OrderToUpload {
    var order: OrderResult
    var orderId: String
    var orderCreated: Bool
    var scanUploaded: Bool
    var photosUploaded: Bool
    var type: String
}
