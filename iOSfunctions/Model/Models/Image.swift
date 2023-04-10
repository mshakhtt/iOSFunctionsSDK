//
//  Image.swift
//  YOUMAWO
//
//  Created by Admin on 8/9/19.
//  Copyright © 2019 YOUMAWO. All rights reserved.
//

import Foundation

public struct Image: Equatable, Hashable, Codable, Identifiable {
    public var id: String
    public var color: String
    public var coreId: String
    public var path: URL?
    public var image: Data?
    
    public init(_ dictionary: [String: Any]) {
        id = dictionary["id"] as? String ?? ""
        color = dictionary["color"] as? String ?? ""
        coreId = dictionary["coreId"] as? String ?? ""
        path = URL(string: (dictionary["path"] as? String)?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")
        image = nil
    }
    
    public init(id: String, color: String, path: URL?, image: Data?, coreId: String) {
        self.id = id
        self.color = color
        self.path = path
        self.image = image
        self.coreId = coreId
    }
    
    public static func == (lhs: Image, rhs: Image) -> Bool {
        return lhs.id == rhs.id &&
            lhs.color == rhs.color &&
            lhs.path == rhs.path &&
            lhs.coreId == rhs.coreId
    }
}
