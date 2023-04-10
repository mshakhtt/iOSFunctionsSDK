//
//  ClientPrices.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 23.03.2023.
//

import Foundation

public struct ClientPrices: Equatable, Hashable, Codable {
    public var currency: String
    public var clientPrice: String
    public var clientCustomLightPrice: String
    
    public init(_ dictionary: [String: Any]) {
        currency = dictionary["currency"]  as? String ?? ""
        clientPrice = ""
        clientCustomLightPrice = ""
        if let price = dictionary["clientPrice"] as? Double,
           let customLightPrice = dictionary["clientCustomLightPrice"] as? Double {
            clientPrice = "\(price)"
            clientCustomLightPrice = "\(customLightPrice)"
        }
    }
    
    public init(currency: String, clientPrice: String, clientCustomLightPrice: String) {
        self.currency = currency
        self.clientPrice = clientPrice
        self.clientCustomLightPrice = clientCustomLightPrice
    }
    
    public init() {
        self.currency = ""
        self.clientPrice = ""
        self.clientCustomLightPrice = ""
    }
    
    static public func == (lhs: ClientPrices, rhs: ClientPrices) -> Bool {
        return lhs.currency == rhs.currency &&
        lhs.clientPrice == rhs.clientPrice &&
        lhs.clientCustomLightPrice == rhs.clientCustomLightPrice
    }
}
