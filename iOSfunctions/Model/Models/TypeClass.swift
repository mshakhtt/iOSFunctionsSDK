//
//  TypeClass.swift
//  OneOfOne
//
//  Created by mshakh on 04.02.2022.
//  Copyright © 2022 YOUMAWO. All rights reserved.
//

import Foundation

public struct TypeClass: Equatable, Hashable, Codable {
    public var id: Int
    public var name: String
    public var typeCode: String
    
    public init(_ dictionary: [String: AnyObject]?) {
        id = dictionary?["id"] as? Int ?? 0
        name = dictionary?["name"] as? String ?? ""
        typeCode = dictionary?["typeCode"] as? String ?? ""
    }
    
    public init(id: Int, name: String, typeCode: String, visiblePortal: Bool) {
        self.id = id
        self.name = name
        self.typeCode = typeCode
    }
    
    public static func == (lhs: TypeClass, rhs: TypeClass) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.typeCode == rhs.typeCode
    }
}
