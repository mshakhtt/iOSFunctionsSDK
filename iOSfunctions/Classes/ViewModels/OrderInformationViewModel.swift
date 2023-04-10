//
//  OrderInformationViewModel.swift
//  OneOfOne
//
//  Created by vbtsukat on 17.11.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

public class OrderInformationViewModel {
    
    // MARK: - Properties
    
    var collectionIndex: Int = 0
    var frameIndex: Int = 0
    var colorIndex: Int = 0
    var hingeIndex: Int = 0
    
    var inscription: String?
    var prototype = false
    var pdleft: Double = 33
    var pdright: Double = 33
    var bc: Int = 0
    var size: Double = 0.0
    var bridgeLength: Double = 0.0
    var templeLength: Int = 0
    var inclination: Int = 0
    var frameSizeName: String?
    var comments: String?
    
    var adjustNosepad = false
    var adjustTempleAngle = false
    var templeBendDesired = false
    var isPersonalFitPlus = false
    var isCustomLightFit = false
    var isStandartFit = false
    
    var frameName: String?
    var collectionName: String?
    
    var isForUploadOrder = false
    var terms = false
    var extendedSettingsVisible = false
    
    var products = [Product]()
    var collections = [Collection]()
    
    var customerInformationViewModel: CustomerInformationViewModel
    
    var zipFile: Data? {
        customerInformationViewModel.zipFileContent
    }
    
    var screenshotFile: Data? {
        customerInformationViewModel.screenshotFileContent
    }
    
    var screenshotFront: Data? {
        customerInformationViewModel.frontScreenShot
    }
    
    var screenshotSide: Data? {
        customerInformationViewModel.sideScreenShot
    }
    
    // MARK: - Init
    
    init(customerInformationViewModel: CustomerInformationViewModel) {
        self.customerInformationViewModel = customerInformationViewModel
        setupBindings()
    }
    
    // MARK: - Methods
    
    func setupBindings() {
        self.collections = getCollections()
        self.products = getProducts()
    }
    
    func getProduct(_ frameName: String) -> Product? {
        var product = Product()
        
        if self.products.isEmpty {
            let products = CollectionsSingleton.shared.getProducts()
            products.forEach({
                if $0.name.removeAllSpaces() == frameName.removeAllSpaces() {
                    product = $0
                }
            })
        } else {
            products.forEach({
                if $0.name.removeAllSpaces() == frameName.removeAllSpaces() {
                    product = $0
                }
            })
        }
        return product
    }
    
    func getProducts() -> [Product] {
        let collections = CollectionsSingleton.shared.getCollections()
        var products = [Product]()
        
        for i in 0 ..< collections.count {
            for j in 0 ..< collections[i].products.count {
                let product = collections[i].products[j]
                products.append(product)
            }
        }
        return products
    }
    
    func getCollections() -> [Collection] {
        return CollectionsSingleton.shared.getCollections()
    }
    
    @objc func params(_ isStandard: Bool) -> [String: String] {
        var sortedCollection = [Collection]()
        let collections = CollectionsSingleton.shared.getCollections()
        if self.collections.isEmpty {
            collections.forEach({
                let currentCollection = $0
                sortedCollection.append(currentCollection)
            })
        } else {
            collections.forEach({ sortedCollection.append($0) })
        }
        
        if sortedCollection.isEmpty { return [:] }
        
        let selectedCollection = sortedCollection[collectionIndex]
        var frames = [String]()
        
        selectedCollection.products.forEach({
            if $0.customizable {
                frames.append($0.name)
            }
        })
        
        guard let frameName = frameSizeName, let product = getProduct(frameName) else {
            return [:]
        }
        
        let sortedColors = product.colors.sorted(by: { $0.colorCode < $1.colorCode })
        let productColor = sortedColors[colorIndex]
        let featureHingeId = product.features[hingeIndex].id
        
        var featureSizeId = 0        
        var params = customerInformationViewModel.getParams(isStandard)
        
        var mandatoryParams = [String: String]()
        var optionalParams = [String: String]()
        var extendedSettingsParams = [String: String]()
        
        if isStandard {
            mandatoryParams = [
                "frameId": product.id,
                "color": productColor.name,
                "featureHingeId": "\(featureHingeId)",
                "modificationSizeId": "\(featureSizeId)"
            ]
        } else {
            mandatoryParams = [
                "frameId": product.id,
                "color": productColor.name,
                "featureHingeId": "\(featureHingeId)",
                "pdLeft": "\(pdleft)",
                "pdRight": "\(pdright)",
                "modificationSizeId": "\(featureSizeId)"
            ]
            
            optionalParams = [
                "inscription": inscription ?? "",
                "baseCurve": "\(bc)",
                "comments": comments ?? ""
            ]
            
            extendedSettingsParams = [
                "size": "\(size)",
                "bridgeLength": "\(bridgeLength)",
                "templeLength": "\(templeLength)",
                "inclination": "\(inclination)"
            ]
        }
        
        for (index, param) in mandatoryParams {
            params[index] = param
        }
        
        for (index, param) in optionalParams {
            params[index] = param
        }
        
        for (index, param) in extendedSettingsParams {
            params[index] = param
        }
        
        return params
    }
}
