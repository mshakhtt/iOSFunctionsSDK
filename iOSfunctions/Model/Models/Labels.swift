//
//  Labels.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 23.03.2023.
//

import Foundation

struct Labels: Codable, Equatable, Hashable {
    var id: Int
    var category: String
    var name: String
    var products: [String]
    
    init(_ dictionary: [String: Any]) {
        id = dictionary["id"]  as? Int ?? 0
        category = dictionary["category"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        products = dictionary["products"] as? [String] ?? [String]()
    }
    
    init(id: Int, category: String, name: String, products: [String]) {
        self.id = id
        self.category = category
        self.name = name
        self.products = products
    }
    
    static func == (lhs: Labels, rhs: Labels) -> Bool {
        return lhs.id == rhs.id &&
        lhs.category == rhs.category &&
        lhs.name == rhs.name
    }
}
