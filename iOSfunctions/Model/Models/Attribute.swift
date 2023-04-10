//
//  Attribute.swift
//  OneOfOne
//
//  Created by mshakh on 04.02.2022.
//  Copyright © 2022 YOUMAWO. All rights reserved.
//

import Foundation

public struct Attribute: Equatable, Hashable, Codable {
    public var id: Int
    public var type: String
    public var value: String
    
    public init(_ dictionary: [String: Any]) {
        id = dictionary["id"] as? Int ?? 0
        type = dictionary["type"] as? String ?? ""
        value = dictionary["value"] as? String ?? ""
    }
    
    public init(id: Int, type: String, value: String) {
        self.id = id
        self.type = type
        self.value = value
    }
    
    static public func == (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.value == rhs.value
    }
}
