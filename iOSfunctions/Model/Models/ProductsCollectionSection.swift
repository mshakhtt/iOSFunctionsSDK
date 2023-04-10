//
//  ProductsCollectionSection.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 06.03.2023.
//

import Foundation
import RxDataSources

public struct ProductsCollectionSection {
    var title: String
    public var items: [Product]
    
    init(title: String, items: [Product]) {
        self.title = title
        self.items = items
    }
}

extension ProductsCollectionSection: SectionModelType {
    public init(original: ProductsCollectionSection, items: [Product]) {
        self = original
    }
}
