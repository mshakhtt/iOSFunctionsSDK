//
//  OrdersLimit.swift
//  YOUMAWO
//
//  Created by Admin on 06.04.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

struct OrdersLimit: Codable {
    var ordersLimit: Int
    var ordersPlaced: Int
    
    init(_ dictionary: [String: Any]) {
        ordersLimit = dictionary["ordersLimit"] as? Int ?? 0
        ordersPlaced = dictionary["ordersPlaced"] as? Int ?? 0
    }
    
    init(ordersLimit: Int, ordersPlaced: Int) {
        self.ordersLimit = ordersLimit
        self.ordersPlaced = ordersPlaced
    }
}
