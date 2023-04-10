//
//  CustomerInformationViewModel.swift
//  OneOfOne
//
//  Created by mshakh on 11.11.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

public class CustomerInformationViewModel {
    var productCatalogDetailViewModel: ProductCatalogDetailViewModel?
    var name: String
    var email: String
    var customerReference: String
    var phoneNumber: String
    var address1: String
    var address2: String?
    var postalCode: String
    var city: String
    var country: String
    var countriesData = [String]()
    var note: String?
    var zipFileContent: Data?
    var screenshotFileContent: Data = Data()
    var cameraViewModel: CameraViewModel?
    var frameIndex: Int
    var collectionName: String
    var frameName: String
    var inscription: String?
    var frontScreenShot: Data?
    var sideScreenShot: Data?
    var comment: String
    
    init() {
        self.name = ""
        self.email = ""
        self.customerReference = ""
        self.zipFileContent = Data()
        self.screenshotFileContent = Data()
        self.cameraViewModel = CameraViewModel()
        self.frameIndex = -1
        self.collectionName = ""
        self.frameName = ""
        self.inscription = ""
        self.frontScreenShot = Data()
        self.sideScreenShot = Data()
        self.address1 = ""
        self.address2 = ""
        self.postalCode = ""
        self.city = ""
        self.country = ""
        self.countriesData = [String]()
        self.note = ""
        self.phoneNumber = ""
        self.comment = ""
    }
    
    init(zipFile: Data?,
         screenshot: Data,
         frameIndex: Int,
         collectionName: String,
         frameName: String,
         inscription: String,
         frontScreenShot: Data?,
         sideScreenShot: Data?,
         address1: String,
         address2: String,
         postalCode: String,
         city: String,
         country: String,
         note: String,
         phoneNumber: String,
         email: String,
         name: String,
         customerReference: String,
         comment: String,
         productCatalogDetailViewModel: ProductCatalogDetailViewModel)
    {
        self.zipFileContent = zipFile
        self.screenshotFileContent = screenshot
        self.frameIndex = frameIndex
        self.collectionName = collectionName
        self.frameName = frameName
        self.inscription = inscription
        self.frontScreenShot = frontScreenShot
        self.sideScreenShot = sideScreenShot
        self.address1 = address1
        self.address2 = address2
        self.postalCode = postalCode
        self.city = city
        self.country = country
        self.note = note
        self.phoneNumber = phoneNumber
        self.email = email
        self.name = name
        self.productCatalogDetailViewModel = productCatalogDetailViewModel
        self.customerReference = customerReference
        self.comment = comment
    }
    
    func getParams(_ isStandardOrder: Bool) -> [String: String] {
        ["name" : name.replaceUmlautSymbols(),
         "email" : email]
    }
}
