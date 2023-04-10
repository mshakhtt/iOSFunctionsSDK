//  Created by mshakh on 8/9/19.
//  Copyright © 2019 YOUMAWO. All rights reserved.

import Foundation

public struct Product: Equatable, Hashable, Codable, Identifiable {
    public var id: String
    public var allowCustomLight: Bool
    public var brandNew: Bool
    public var catalogUrl: URL?
    public var category: String
    public var collection: String
    public var bestseller: Bool
    public var colorCount: Int
    public var colors: [Color]
    public var customizable: Bool
    public var description: String
    public var enabled: Bool
    public var features: [Feature]
    public var form: String
    public var imageUrl: URL?
    public var imageB64: String = ""
    public var image: Data?
    public var images: [Image]
    public var inArVTO: Bool
    public var inScanVTO: Bool
    public var name: String
    public var sellOff: Bool
    public var sex: String
    public var sizeUrl: URL?
    public var sizeImage: Data?
    public var slug: String
    public var style: String
    public var localSettings: LocalSettings
    public var clientPrices: ClientPrices
    
    public init(_ dictionary: [String: Any]) {
        id = dictionary["id"] as? String ?? ""
        allowCustomLight = dictionary["allowCustomLight"] as? Bool ?? false
        brandNew = dictionary["brandNew"] as? Bool ?? false
        catalogUrl = URL(string: dictionary["catalogUrl"] as? String ?? "")
        category = dictionary["category"] as? String ?? ""
        collection = dictionary["collection"] as? String ?? ""
        bestseller = dictionary["bestseller"] as? Bool ?? false
        colorCount = dictionary["colorCount"] as? Int ?? 0
        colors = (dictionary["colors"] as? Array ?? []).map { Color($0) }.sorted(by: { $0.colorCode < $1.colorCode })
        customizable = dictionary["customizable"] as? Bool ?? false
        description = dictionary["description"] as? String ?? ""
        enabled = dictionary["enabled"] as? Bool ?? false
        features = (dictionary["features"] as? Array ?? []).map { Feature($0) }
        form = dictionary["form"] as? String ?? ""
        imageUrl = URL(string: dictionary["imageUrl"] as? String ?? "")
        image = nil
        images = (dictionary["images"] as? Array ?? []).map { Image($0) }
        inArVTO = dictionary["inArVTO"] as? Bool ?? false
        inScanVTO = dictionary["inScanVTO"] as? Bool ?? false
        name = dictionary["name"] as? String ?? ""
        sellOff = dictionary["sellOff"] as? Bool ?? false
        sex = dictionary["sex"] as? String ?? ""
        sizeUrl = URL(string: dictionary["sizeUrl"] as? String ?? "")
        sizeImage = nil
        slug = dictionary["slug"] as? String ?? ""
        style = dictionary["style"] as? String ?? ""
        localSettings = LocalSettings()
        clientPrices = ClientPrices(dictionary["clientPrices"] as? [String: Any] ?? [:])
    }
    
    public init(id: String,
         allowCustomLight: Bool,
         brandNew: Bool,
         catalogUrl: URL?,
         category: String,
         collection: String,
         bestseller: Bool,
         colorCount: Int,
         colors: [Color],
         customizable: Bool,
         description: String,
         enabled: Bool,
         features: [Feature],
         form: String,
         imageUrl: URL?,
         image: Data?,
         images: [Image],
         inArVTO: Bool,
         inScanVTO: Bool,
         name: String,
         sellOff: Bool,
         sex: String,
         sizeUrl: URL?,
         sizeImage: Data?,
         slug: String,
         style: String,
         localSettings: LocalSettings = LocalSettings(),
         clientPrices: ClientPrices
    ) {
        self.id = id
        self.allowCustomLight = allowCustomLight
        self.brandNew = brandNew
        self.catalogUrl  = catalogUrl
        self.category = category
        self.collection = collection
        self.bestseller = bestseller
        self.colorCount = colorCount
        self.colors = colors
        self.customizable = customizable
        self.description = description
        self.enabled = enabled
        self.features = features
        self.form = form
        self.imageUrl = imageUrl
        self.image = image
        self.images = images
        self.inArVTO = inArVTO
        self.inScanVTO = inScanVTO
        self.name = name
        self.sellOff = sellOff
        self.sex = sex
        self.sizeUrl = sizeUrl
        self.sizeImage = sizeImage
        self.slug = slug
        self.style = style
        self.localSettings = localSettings
        self.clientPrices = clientPrices
    }
    
    public init() {
        self.id = ""
        self.allowCustomLight = false
        self.brandNew = false
        self.catalogUrl = URL(string: "")
        self.category = ""
        self.collection = ""
        self.bestseller = false
        self.colorCount = 0
        self.colors = [Color]()
        self.customizable = false
        self.description = ""
        self.enabled = false
        self.features = [Feature]()
        self.form = ""
        self.imageUrl = URL(string: "")
        self.imageB64 = ""
        self.image = Data()
        self.images = [Image]()
        self.inArVTO = false
        self.inScanVTO = false
        self.name = ""
        self.sellOff = false
        self.sex = ""
        self.sizeUrl = URL(string: "")
        self.sizeImage = Data()
        self.slug = ""
        self.style = ""
        self.localSettings = LocalSettings()
        self.clientPrices = ClientPrices()
    }
    
    public static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id &&
        lhs.allowCustomLight == rhs.allowCustomLight &&
        lhs.brandNew == rhs.brandNew &&
        lhs.catalogUrl  == rhs.catalogUrl &&
        lhs.category == rhs.category &&
        lhs.colorCount == rhs.colorCount &&
        lhs.bestseller == rhs.bestseller &&
        lhs.colors == rhs.colors &&
        lhs.customizable == rhs.customizable &&
        lhs.description == rhs.description &&
        lhs.enabled == rhs.enabled &&
        lhs.features == rhs.features &&
        lhs.form == rhs.form &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.images == rhs.images &&
        lhs.inArVTO == rhs.inArVTO &&
        lhs.inScanVTO == rhs.inScanVTO &&
        lhs.name == rhs.name &&
        lhs.sellOff == rhs.sellOff &&
        lhs.sex == rhs.sex &&
        lhs.sizeUrl == rhs.sizeUrl &&
        lhs.slug == rhs.slug &&
        lhs.style == rhs.style &&
        lhs.clientPrices == rhs.clientPrices
    }
}
