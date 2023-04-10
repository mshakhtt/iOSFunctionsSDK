//
//  FilteredProductsCollectionSection.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 06.03.2023.
//

import Foundation
import RxDataSources

public struct FilteredProductsCollectionSection: Codable {
    var title: String
    public var items: [Product]
    
    init(title: String, items: [Product]) {
        self.title = title
        self.items = items
    }
}

extension FilteredProductsCollectionSection: SectionModelType {
    public init(original: FilteredProductsCollectionSection, items: [Product]) {
        self = original
    }
}
