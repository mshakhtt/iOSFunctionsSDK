//
//  DataManager.swift
//  YOUMAWO
//
//  Created by Andreas Wörner on 24.12.18.
//  Copyright © 2018 YOUMAWO. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

public class DataManager {
    
    // MARK: - Properties
    
    fileprivate let productCollectionRel: BehaviorRelay<[ProductsCollectionSection]> = BehaviorRelay.init(value: [])
    fileprivate let filteredProductCollectionRel: BehaviorRelay<[FilteredProductsCollectionSection]> = BehaviorRelay.init(value: [])
    
    let disposeBag = DisposeBag()
    var collectionList = [String]()
    let navController = UINavigationController()
    let model = Model()
    private let localization = Localization.shared
    
    static var shared: DataManager {
        return DataManager()
    }
    
    // MARK: - Init
    
    init() {
        loadProductsCollection()
        loadVTOCollection()
    }
    
    // MARK: - Methods
    
    func loadProductsCollection() {
        NotificationCenter.default.rx.notification(.loadProductsCollection).map { (notification) -> [ProductsCollectionSection] in
            if notification.object is [Collection] {
                let collections: [Collection] = notification.object as! [Collection]
                
                let productSections = collections.map({ ProductsCollectionSection(title: $0.title, items: $0.products)})
                
                self.collectionList = [self.localization.getLocalizedString(forKey:  LocalConstants.Localizable.ProductsCatalog.selectCollection) ?? "Select collection"]
                
                productSections.forEach { productSection in
                    self.collectionList.append(productSection.items.first?.collection.lowercased().capitalizingFirstLetter() ?? "")
                }
                return productSections
            }
            return []
        }.bind(to: productCollectionRel).disposed(by: disposeBag)
    }
    
    func loadVTOCollection() {
        NotificationCenter.default.rx.notification(.loadVTOCollection).map { (notification) -> [FilteredProductsCollectionSection] in
            if notification.object is [Collection] {
                let collections: [Collection] = notification.object as! [Collection]
                
                var productSections = collections.map({ FilteredProductsCollectionSection(title: $0.title, items: $0.products.filter {
                    $0.inScanVTO
                })})
                
                for i in 0 ..< productSections.count {
                    let productSection = productSections[i]
                    
                    for j in 0 ..< productSection.items.count {
                        let product = productSection.items[j]
                        
                        if let image = product.images.first {
                            let normalizesId = CollectionsSingleton.shared.getNormalizedImageId(imageId: image.coreId)
                            let imageName = "\(product.name)_\(image.color)_\(normalizesId)"
                            var imageData = Data()
                            
                            if let data = UIImage(named: imageName)?.pngData() {
                                imageData = data
                            } else {
                                imageData = UIImage(named: "LOGO_YMW_black.png")?.pngData() ?? Data()
                            }
                            productSections[i].items[j].imageB64 = DataManager.base64Data(data: imageData)
                        } else {
                            productSections[i].items[j].imageB64 = DataManager.base64Data(data: UIImage(named: "LOGO_YMW_black.png")?.pngData() ?? Data())
                        }
                    }
                }
                self.collectionList = [self.localization.getLocalizedString(forKey:  LocalConstants.Localizable.ProductsCatalog.selectCollection) ?? "Select collection"]
                
                productSections.forEach { productSection in
                    self.collectionList.append(productSection.items.first?.collection.lowercased().capitalizingFirstLetter() ?? "")
                }
                return productSections
            }
            return []
        }.bind(to: filteredProductCollectionRel).disposed(by: disposeBag)
    }
    
    static func base64Data(data: Data) -> String {
        let str = data.base64EncodedString(options: .lineLength64Characters)
        return "data:image/png;base64,\(str.replacingOccurrences(of: "\r\n", with: ""))"
    }
}

// MARK: - Extensions

extension Reactive where Base: DataManager {
    public var sec: Observable<[ProductsCollectionSection]> {
        return base.productCollectionRel.map { productsCollection -> [ProductsCollectionSection] in
            return productsCollection
        }
    }
}

extension Reactive where Base: DataManager {
    public var secVTO: Observable<[FilteredProductsCollectionSection]> {
        return base.filteredProductCollectionRel.map { productsCollection -> [FilteredProductsCollectionSection] in
            return productsCollection
        }
    }
}
