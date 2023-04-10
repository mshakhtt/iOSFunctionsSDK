//
//  Feature.swift
//  OneOfOne
//
//  Created by mshakh on 27.04.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

public struct Feature: Equatable, Hashable, Codable, Identifiable {
    public var id: Int
    public var attributes: [Attribute]
    public var coreId: String
    public var modified: String
    public var name: String
    public var type: TypeClass
    public var weclappId: String
    
    public init(_ dictionary: [String: Any]) {
        id = dictionary["id"] as? Int ?? 0
        attributes = (dictionary["attributes"] as? Array ?? []).map { Attribute($0) }
        coreId = dictionary["coreId"] as? String ?? ""
        modified = dictionary["modified"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        type = TypeClass(dictionary["type"] as? [String: AnyObject])
        weclappId = dictionary["weclappId"] as? String ?? ""
    }
    
    public init(id: Int, attributes: [Attribute], coreId: String, modified: String, name: String, type: TypeClass, weclappId: String) {
        self.id = id
        self.coreId = coreId
        self.modified = modified
        self.attributes = attributes
        self.name = name
        self.type = type
        self.weclappId = weclappId
    }
    
    public static func == (lhs: Feature, rhs: Feature) -> Bool {
        return lhs.id == rhs.id &&
        lhs.attributes == rhs.attributes &&
        lhs.coreId == rhs.coreId &&
        lhs.modified == rhs.modified &&
        lhs.name == rhs.name &&
        lhs.type == rhs.type &&
        lhs.weclappId == rhs.weclappId
    }
}
