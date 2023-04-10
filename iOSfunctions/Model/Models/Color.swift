//
//  Color.swift
//  YOUMAWO
//
//  Created by Admin on 8/9/19.
//  Copyright © 2019 YOUMAWO. All rights reserved.
//

import Foundation

public struct Color: Equatable, Hashable, Codable, Identifiable {
    public var id: Int
    public var material: String
    public var name: String
    public var hex: String
    public var availableCount: Int
    public var category: String
    public var colorCode: String
    public var rebate: Bool
    
    public init(_ dictionary: [String: Any]) {
        id = dictionary["id"] as? Int ?? 0
        material = dictionary["material"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        hex = dictionary["hex"] as? String ?? ""
        availableCount = dictionary["availableCount"] as? Int ?? 0
        category = dictionary["category"] as? String ?? ""
        colorCode = dictionary["colorCode"] as? String ?? ""
        rebate = dictionary["rebate"] as? Bool ?? false
    }
    
    public init(id: Int, material: String, name: String, hex: String, availableCount: Int, category: String, colorCode: String, rebate: Bool) {
        self.id = id
        self.material = material
        self.name = name
        self.hex = hex
        self.availableCount = availableCount
        self.category = category
        self.colorCode = colorCode
        self.rebate = rebate
    }
    
    public static func == (lhs:Color, rhs:Color) -> Bool {
        return  lhs.id == rhs.id &&
        lhs.material == rhs.material &&
        lhs.name == rhs.name &&
        lhs.hex == rhs.hex &&
        lhs.availableCount == rhs.availableCount &&
        lhs.category == rhs.category &&
        lhs.colorCode == rhs.colorCode &&
        lhs.rebate == rhs.rebate
    }
}
