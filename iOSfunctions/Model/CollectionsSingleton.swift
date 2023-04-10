//
//  CollectionsSingleton.swift
//  YOUMAWO
//
//  Created by Admin on 19.12.2020.
//  Copyright © 2020 YOUMAWO. All rights reserved.
//

import UIKit

public struct CollectionsSingleton {
    
    // MARK: - Constants
    
    private struct Constants {
        static let collectionsFileName = "savedCollections.txt"
        static let countriesFileName = "savedCountries.txt"
        static let favoriteFramesFileName = "favoriteFrames.txt"
    }
    
    // MARK: - Properties
    
    static var shared = CollectionsSingleton()
    
    public typealias CompletionHandler = (_ success: Bool) -> Void
    typealias CompletionHandlerString = (_ success: String) -> Void
    
    var anonimusToken: String?
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Methods
    
    func getIndexInFavoritesByProduct(product: Product) -> Int {
        let favorites = getFavoritesFrames()
        return favorites.firstIndex(where: { $0.id == product.id }) ?? -1
    }
    
    func getFeatureColors(product: Product, type: String) -> [ProductColor] {
        var colors = [ProductColor]()
        
        for feature in product.features {
            if feature.type.typeCode == type {
                var name = ""
                var hex = ""
                var featureId = -1
                
                for attribute in feature.attributes {
                    if attribute.type == "HEX" {
                        hex = attribute.value
                        featureId = feature.id
                    }
                    if attribute.type == "COLOR" {
                        name = attribute.value
                    }
                }
                colors.append(ProductColor(featureId: featureId, name: name, hex: hex))
            }
        }
        if type == LocalConstants.FeatureType.hingeColor {
            colors = colors.sorted { $0.name > $1.name }
        }
        
        return colors
    }
    
    func saveFavoritesFrames(products: [Product], functionName: String) {
        do {
            let jsonData = try JSONEncoder().encode(products)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else { return }
            
            DocumentDirectoryManager.save(text: jsonString, toDirectory: DocumentDirectoryManager.documentDirectory(), withFileName: Constants.favoriteFramesFileName)
        } catch let err  {
            print("CollectionSingltone.saveFavoritesFrames from \(functionName) \(err.localizedDescription)")
        }
    }
    
    func getFavoritesFrames() -> [Product] {
        var favoritesFrames = [Product]()
        
        self.read(fromDocumentsWithFileName: Constants.favoriteFramesFileName) { (filePath) in
            do {
                let favoritesData = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                
                favoritesFrames = try JSONDecoder().decode([Product].self, from: favoritesData)
            }  catch let err  {
                print("CollectionSingltone.getFavoritesFrames \(err.localizedDescription)")
            }
        }
        return favoritesFrames
    }
    
    func removeFavoritesFrames() {
        guard let filePathStr = DocumentDirectoryManager.append(toPath: DocumentDirectoryManager.documentDirectory(), withPathComponent: Constants.favoriteFramesFileName) else {
            return
        }
        let filePath = URL(fileURLWithPath: filePathStr)
        
        try? FileManager.default.removeItem(at: filePath)
    }
    
    func getDataFromFile(fileName: String) -> Data {
        var resData = Data()
        
        let file = DocumentDirectoryManager.getDocumentsURL().appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: file.path) {
            print("\(#function) The file \(fileName) is not exists")
        }
        do {
            let fileData = try Data(contentsOf: file)
            resData = fileData
        } catch let error {
            print("Error: " + error.localizedDescription)
        }
        
        return resData
    }
    
    private func read(fromDocumentsWithFileName fileName: String, completionHandler: @escaping CompletionHandlerString) {
        guard let filePath = DocumentDirectoryManager.append(toPath: DocumentDirectoryManager.documentDirectory(), withPathComponent: fileName) else {
            return
        }
        do {
            completionHandler(filePath)
        } catch {
            print("\(#function) Error reading saved file \(fileName)")
        }
    }
    
    func checkIfProductInFavorites(product: Product) -> Bool {
        let favorites = getFavoritesFrames()
        
        for favorite in favorites {
            if favorite.id == product.id {
                return true
            }
        }
        return false
    }
    
    func getDefaultFrameMaterialFeatureId(product: Product) -> Int {
        var id = -1
        
        for feature in product.features {
            if feature.type.typeCode == LocalConstants.FeatureType.templeMaterial {
                id = feature.id
            }
        }
        return id
    }
    
    func getDefaultFrameSizeFeatureId(product: Product) -> Int {
        var id = -1
        
        for feature in product.features {
            if feature.type.typeCode == LocalConstants.FeatureType.frameSize {
                for attribute in feature.attributes {
                    if attribute.value == "M" && attribute.type == "SIZE" {
                        id = feature.id
                    }
                }
            }
        }
        return id
    }
    
    func runUpdateCollectionInBackground() {
        var backgroundTaskID = UIBackgroundTaskIdentifier(rawValue: 4223)
        
        DispatchQueue.global().async {
            // Request the task assertion and save the ID.
            backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "com.OneOfOne.uploadProductCollections") {
                // End the task if time expires.
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
                backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 86400, repeats: true) { timer in
            print("\(#function) update collections timer runed")
            loadCollectionsData { (res) in }
        }
    }
    
    func loadCountries(_ completionHandler: @escaping CompletionHandler) {
        guard let url = UserDefaults.standard.backendUrl?.appending("countries") else {
            return
        }
        
        guard let token = UserManager.currentUser?.access_token else {
            return
        }
        
        let parameters = ["token": token]
        
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                completionHandler(false)
                return
            }
            do {
                if let _ = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    let jsonStr = String(data: data!, encoding: .utf8)
                    if let jsonString = jsonStr {
                        DocumentDirectoryManager.save(text: jsonString, toDirectory: DocumentDirectoryManager.documentDirectory(), withFileName: Constants.countriesFileName)
                        completionHandler(true)
                        return
                    }
                }
            } catch {
                print("\(#function) Countries is not saved Error: \(error.localizedDescription)")
                completionHandler(false)
                return
            }
        }
        task.resume()
    }
    
    func getProductBy(productId: String) -> Product {
        let products = getProducts()
        return products.first(where: { $0.id == productId }) ?? Product()
    }
    
    public func loadCollectionsData(_ completionHandler: @escaping CompletionHandler) {
        guard let url = UserDefaults.standard.backendUrl?.appending("products") else {
            print("\(#function). CollectionsSingleton.loadCollectionsData - Error getting backend url")
            return
        }
        
        var parameters = [String: String]()
        
        if Common.isOptician() {
            if let token = UserManager.currentUser?.access_token {
                parameters["token"] = token
            }
        }
        
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print("CollectionsSingleton.loadCollectionsData - Error:", error.localizedDescription)
                completionHandler(false)
                return
            }
            do {
                if let _ = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    let jsonStr = String(data: data!, encoding: .utf8)
                    
                    if let jsonString = jsonStr {
                        DocumentDirectoryManager.save(text: jsonString, toDirectory: DocumentDirectoryManager.documentDirectory(), withFileName: Constants.collectionsFileName)
                        NotificationCenter.default.post(name: .dismissLoadingView, object: nil)
                        completionHandler(true)
                        return
                    }
                }
            } catch {
                print("\(#function) Collections are not saved. Error: \(error.localizedDescription)")
                completionHandler(false)
                return
            }
        }
        task.resume()
    }
    
    func filterCollections(_ collections: [Collection]) -> [Collection] {
        var filteredCollections = [Collection]()
        
        for collection in collections {
            var filteredProducts = [Product]()
            var filteredCollection = collection
            
            for product in filteredCollection.products {
                var filteredProduct = product
                if CollectionsSingleton.shared.doesProductHaveFrameModels(id: product.id, product: product) {
                    let filteredImages = product.images.filter({ $0.color != "" })
                    filteredProduct.images = filteredImages
                    filteredProducts.append(filteredProduct)
                }
            }
            
            filteredCollection.products = filteredProducts
            
            if filteredCollection.products.count != 0 {
                filteredCollections.append(filteredCollection)
            }
        }
        return filteredCollections
    }
    
    func getCountries() -> [Country] {
        var res = [Country]()
        
        self.read(fromDocumentsWithFileName: Constants.countriesFileName) { (filePath) in
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let jsonObject = json["object"] as? Array<Any> {
                        let countries: [Country] = jsonObject.compactMap { dict in
                            guard let dict = dict as? [String: Any] else { return nil }
                            
                            let country = Country(dict)
                            return country
                        }
                        res = countries
                    }
                }
            } catch {
                res = [Country]()
            }
        }
        return res
    }
    
    func getFilteredCollectionsByPath(path: String) -> [Collection] {
        var filteredCollections = [Collection]()
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let jsonObject = json["object"] as? Array<Any> {
                    let collections: [Collection] = jsonObject.compactMap { dictionary in
                        guard let dictionary = dictionary as? [String: Any] else { return nil }
                        
                        let collection = Collection(dictionary)
                        
                        return collection
                    }
                    filteredCollections = collections
                }
            }
        } catch {
            filteredCollections = [Collection]()
        }
        return filteredCollections
    }
    
    func getCollections() -> [Collection] {
        var resultingCollections = [Collection]()
        
        self.read(fromDocumentsWithFileName: Constants.collectionsFileName) { (filePath) in
            resultingCollections = getFilteredCollectionsByPath(path: filePath)
        }
        return filterCollections(resultingCollections)
    }
    
    func getLocalCollections() -> [Collection] {
        var resultingCollections = [Collection]()
        
        if let filePath = Bundle.main.path(forResource: "products", ofType: "json") {
            resultingCollections = getFilteredCollectionsByPath(path: filePath)
        }
        return filterCollections(resultingCollections)
    }
    
    func getBestSellers(collections: [Collection]) -> [Product] {
        var bestSellers = [Product]()
        
        for collection in collections {
            for product in collection.products {
                if product.bestseller {
                    bestSellers.append(product)
                }
            }
        }
        return bestSellers
    }
    
    func getVTOCollections() -> [Collection] {
        let collections = getCollections()
        
        var VTOCollectionsFull = [Collection]()
        
        for collection in collections {
            for product in collection.products {
                if product.inScanVTO {
                    if filterParameters.collections.count == 0 {
                        VTOCollectionsFull.append(collection)
                        break
                    } else {
                        for name in filterParameters.collections {
                            if collection.name.uppercased() == name.uppercased() {
                                if !VTOCollectionsFull.contains(collection) {
                                    VTOCollectionsFull.append(collection)
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
        var filteredCollections = [Collection]()
        
        for collection in VTOCollectionsFull {
            var filteredProducts = [Product]()
            var filteredCollection = collection
            for product in collection.products {
                if CollectionsSingleton.shared.doesProductHaveFrameModels(id: product.id, product: product) {
                    if filterParameters.frameName == "" {
                        filteredProducts.append(product)
                    } else {
                        if product.name.containsIgnoringCase(find: filterParameters.frameName) {
                            filteredProducts.append(product)
                        }
                    }
                }
            }
            
            if filterParameters.statuses.count != 0 {
                for (key, value) in filterParameters.statuses {
                    if key == "New" {
                        filteredProducts = filteredProducts.filter {$0.brandNew == value}
                    }
                    
                    if key == "On Sale" {
                        filteredProducts = filteredProducts.filter {$0.sellOff == value}
                    }
                }
            }
            
            filteredCollection.products = filteredProducts
            filteredCollections.append(filteredCollection)
        }
        var VTOCollections = [Collection]()
        
        for collection in filteredCollections {
            if collection.products.count != 0 {
                VTOCollections.append(collection)
            }
        }
        return VTOCollections
    }
    
    func getProducts() -> [Product] {
        var products = [Product]()
        let VTOCollections = getVTOCollections()
        
        for collect in VTOCollections {
            for product in collect.products {
                products.append(product)
            }
        }
        return products
    }
    
    func doesProductHaveFrameModels(id: String, product: Product) -> Bool {
        if product.id != id {
            return false
        }
        
        let productName = getProductNormalizedName(product: product, collectionName: product.collection)
        
        var templeModelFile = ""
        let frameModelFile = "\(productName)_\(product.collection)"
        let configFileFile = "\(productName)_\(product.collection)_Config"
        
        for feature in product.features {
            if feature.type.typeCode == LocalConstants.FeatureType.templeName {
                templeModelFile = feature.name
            }
        }
        
        guard let _ = Bundle.main.path(forResource: frameModelFile, ofType: "txt") else { return false }
        guard let _ = Bundle.main.path(forResource: templeModelFile, ofType: "txt") else { return false }
        guard let _ = Bundle.main.path(forResource: configFileFile, ofType: "txt") else { return false }
        
        return true
    }
    
    // We need to prettify the product name to avoid naming issues. Some names of products on the server have bad naming.
    func getProductNormalizedName(product: Product, collectionName: String) -> String {
        var productName = product.name.removeAllSpaces()
        
        // Some products have collection name inside itself names, to avoid double collection naming in stored files we remove the collection name from the product name.
        if productName.contains(collectionName) {
            productName = productName.replacingOccurrences(of: collectionName, with: "")
        }
        return productName
    }
    
    func getTempleBase64By(product: Product) -> String {
        var templeModelFile = ""
        var templeModel = ""
        
        for feature in product.features {
            if feature.type.typeCode == LocalConstants.FeatureType.templeName {
                templeModelFile = feature.name
            }
        }
        
        if let path = Bundle.main.path(forResource: templeModelFile, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let text = data.replacingOccurrences(of: "\n", with: "")
                
                templeModel = text
            } catch {
                print(error)
                return ""
            }
        }
        
        return templeModel
    }
    
    func getFullFrameBase64By(product: Product) -> FullFrame {
        var productName = product.name.removeAllSpaces()
        var templeModel = ""
        var frameModel = ""
        var configFile = ""
        let collectionName = product.collection
        
        if productName.contains(collectionName) {
            productName = productName.replacingOccurrences(of: collectionName, with: "")
        }
        
        templeModel = getTempleBase64By(product: product)
        
        if templeModel == "" {
            return FullFrame()
        }
        
        let frameModelFile = "\(productName)_\(collectionName)"
        if let path = Bundle.main.path(forResource: frameModelFile, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let text = data.replacingOccurrences(of: "\n", with: "")
                
                frameModel = text
            } catch {
                print(error)
            }
        }
        
        let configFileFile = "\(productName)_\(collectionName)_Config"
        if let path = Bundle.main.path(forResource: configFileFile, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let text = data.replacingOccurrences(of: "\n", with: "")
                
                configFile = text
            } catch {
                print(error)
            }
        }
        return FullFrame(frameModel: frameModel, templeModel: templeModel, frameConfig: configFile, frameId: product.id)
    }
    
    func getImageBy(coreId: String) -> Data? {
        let res = Data()
        let collections = getVTOCollections()
        for col in collections {
            for product in col.products {
                for image in product.images {
                    if image.coreId == coreId {
                        let imageName = "\(product.name)_\(image.color)_\(coreId).png"
                        let data = UIImage(named: imageName)?.pngData()
                        return data
                    }
                }
            }
        }
        return res
    }
    
    mutating func setAnoimusToken(anonimusToken: String) {
        self.anonimusToken = anonimusToken
    }
    
    func getAnonimusToken() -> String? {
        return self.anonimusToken
    }
    
    func getNormalizedImageId(imageId: String) -> String {
        var normalizedImageId = imageId
        
        if !normalizedImageId.contains(".png") {
            normalizedImageId.append(".png")
        }
        
        if normalizedImageId.contains("https://cdn.youmawo.com/") {
            normalizedImageId = normalizedImageId.replacingOccurrences(of: "https://cdn.youmawo.com/", with: "")
        }
        return normalizedImageId
    }
}
