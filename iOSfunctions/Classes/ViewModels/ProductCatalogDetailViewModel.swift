//
//  ProductCatalogDetailViewModel.swift
//  YOUMAWO
//
//  Created by Andreas Wörner on 29.12.18.
//  Copyright © 2018 YOUMAWO. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ProductCatalogDetailViewModel: NSObject {
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    let dataManager: DataManager
    fileprivate let loginManager: LoginManager
    
    let product: Product
    
    fileprivate let previewImagesRel = BehaviorRelay(value: [Data?]())
    fileprivate let previewImagesUrlRel = BehaviorRelay(value: [String?]())
    fileprivate let selectedIndexRel = BehaviorRelay(value: 0)
    fileprivate let selectedColorRel: BehaviorRelay<Color?>
    lazy var title: String = product.name
    lazy var collection = product.collection
    lazy var price = product.clientPrices.clientCustomLightPrice
    
    lazy var shape = product.form
    lazy var style = product.style
    
    lazy var colors: [Color] = product.colors
    lazy var productUrl: URL? = product.catalogUrl ?? URL(string: "")
    
    var selectedIndex: Int {
        set {
            selectedIndexRel.accept(newValue)
        }
        get {
            return selectedIndexRel.value
        }
    }
    
    var selectedColor: Color? {
        set {
            selectedColorRel.accept(newValue)
        }
        get {
            return selectedColorRel.value
        }
    }
    
    var previewImages: [Data?] {
        return previewImagesRel.value
    }
    
    var previewImageWithURL: [String?] {
        return previewImagesUrlRel.value
    }
    
    var vtoViewModel: VTOViewModel
    
    // MARK: - Init
    
    init(product: Product, dataManager: DataManager, loginManager: LoginManager, vtoViewModel: VTOViewModel) {
        self.product = product
        self.dataManager = dataManager
        self.loginManager = loginManager
        self.vtoViewModel = vtoViewModel
        
        if !(product.colors.isEmpty) {
            selectedColorRel = BehaviorRelay<Color?>(value: product.colors.first)
        } else {
            selectedColorRel = BehaviorRelay<Color?>(value: nil)
        }
        
        super.init()
        setupBindings()
    }
    
    // MARK: - Methods
    
    func setupBindings() {
        selectedColorRel.map { [product] (productColor) -> [Data?] in
            let prodName = product.name
            var imagesData = [Data?]()
            
            if let colorCode = productColor?.colorCode {
                var filteredImages = product.images.filter({ $0.color == productColor?.colorCode })
                
                if let filteredFirstImage = product.images.first {
                    filteredImages.append(filteredFirstImage)
                }
                
                filteredImages = filteredImages.uniqued()
                
                for image in filteredImages {
                    var currentImageId = ""
                    
                    if UserDefaults.standard.backendUrl?.contains("portal") == true {
                        currentImageId = image.id
                    } else {
                        currentImageId = image.coreId
                    }
                    
                    let imageData = UIImage(named: "\(prodName)_\(colorCode)_\(currentImageId).png")?.pngData()
                    
                    if let imgDT = imageData {
                        imagesData.append(imgDT)
                    }
                }
            }
            return imagesData
            
        }.bind(to: self.previewImagesRel).disposed(by: disposeBag)
    }
}

// MARK: - Extensions

extension Reactive where Base: ProductCatalogDetailViewModel {
    public var image: Observable<Data> {
        return Observable.combineLatest(previewImages, self.base.selectedIndexRel) { pri, rel in
            
            var imageData = Data()
            var imgDt: Data?
            
            let prodName = self.base.product.name
            if let colorCode = self.base.product.images.first?.color {
                
                let product = self.base.product
                var currentImageId = ""
                let image = product.images.first
                if UserDefaults.standard.backendUrl?.contains("portal") == true {
                    if let imageId = image?.id {
                        currentImageId = imageId
                    }
                } else {
                    if let imageId = image?.coreId {
                        currentImageId = imageId
                    }
                }
                imgDt = (UIImage(named: "\(prodName)_\(colorCode)_\(currentImageId).png")?.pngData())
            }
            
            if let imgData = pri.count > rel ? pri[rel] : imgDt ?? Data () {
                imageData = imgData
            }
            
            return imageData
        }.distinctUntilChanged()
    }
    
    var imageFromUrl: Observable<String> {
        
        return Observable.combineLatest(previewImagesUrl, self.base.selectedIndexRel) { pri, rel in
            
            var imageData = String()
            
            if let imgData = pri.count > rel ? pri[rel] : self.base.product.imageUrl?.absoluteString {
                imageData = imgData
            }
            
            return imageData
        }.distinctUntilChanged()
    }
    
    var previewImagesUrl: Observable<[String?]> {
        return base.previewImagesUrlRel.asObservable().distinctUntilChanged()
    }
    
    public var previewImages: Observable<[Data?]> {
        return base.previewImagesRel.asObservable().distinctUntilChanged()
    }
}
