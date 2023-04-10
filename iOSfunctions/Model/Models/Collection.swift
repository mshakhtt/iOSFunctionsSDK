//
//  Collection.swift
//  YOUMAWO
//
//  Created by Admin on 8/9/19.
//  Copyright © 2019 YOUMAWO. All rights reserved.
//

import Foundation
import RxDataSources

public struct Collection: Equatable, Hashable, Codable, Identifiable {
    public var id: Int
    public var category: String
    public var name: String
    public var position: Int
    public var products: [Product]
    public var title: String
    
    public init(_ dictionary: [String: Any]) {
        id = dictionary["id"] as? Int ?? 0
        category = dictionary["category"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        position = dictionary["position"] as? Int ?? 0
        products = (dictionary["products"] as? Array ?? []).map { Product($0) }.sorted(by: { $0.name < $1.name })
        title = dictionary["title"] as? String ?? ""
    }
    
    public init(id: Int, category: String, name: String, position: Int, products: [Product], title: String) {
        self.id = id
        self.category = category
        self.name = name
        self.position = position
        self.products = products
        self.title = title
    }
    
    public init() {
        self.id = 0
        self.category = ""
        self.name = ""
        self.position = 0
        self.products = [Product]()
        self.title = ""
    }
    
    public static func == (lhs: Collection, rhs: Collection) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
        && lhs.category == rhs.category
        && lhs.position == rhs.position
        && lhs.products == rhs.products
        && lhs.title == rhs.title
    }
}
