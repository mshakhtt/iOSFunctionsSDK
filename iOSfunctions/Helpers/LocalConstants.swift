//
//  Constants.swift
//  OneOfOne
//
//  Created by vbtsukat on 24.06.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import UIKit

struct LocalConstants {
    
    struct VTOSlidersMinMaxValues {
        static let sizeMinValue = -10
        static let sizeMaxValue = 10
        
        static let bridgeMinValue = -5
        static let bridgeMaxValue = 5
        
        static let pantoscopicMinValue = -10
        static let pantoscopicMaxValue = 10
        
        static let baseCurveMinValue = 1
        static let baseCurveMaxValue = 5
        static let baseCurveCenterValue = 3
        
        static let templeLenghtMinValue = -25
        static let templeLenghtMaxValue = 25
    }
    
    struct FrameDefaultSettings {
        static let frameSize = 0
        static let bridgeSize = 0
        static let pantoscopicAngle = 0
        static let baseCurve = 4
        static let templeLenght = 0
        
        static let frameColor = UIColor.frameColor
        static let hingeColor = UIColor.hingeColor
    }
    
    struct InscriptionLimits {
        static let ACCEPTABLE_CHARACTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,*? &%."
        static let ACCEPTABLE_LIMITS_REGEX = "^$|^[A-Za-z0-9@. \\-\\+()\\/:]+$"
        static let inscriptionMaxLength = 20
        static let phoneNumberMaxLength = 16
    }
    
    static let orderReuploadDelayInSec: Double = 10.0
    
    struct ScanningSDKProgressbar {
        static let progressingFilledViewHeight: CGFloat = 14.0
    }
    
    struct FeatureType {
        static let templeMaterial = "TM"
        static let hingeColor = "HC"
        static let templeSize = "TS"
        static let templeName = "TN"
        static let templeColor = "TC"
        static let glassColor = "GC"
        static let frameSize = "FS"
        static let hinge = "HINGE"
    }
    
    struct ScanningSDKScanningAnimation {
        static let animationDuration = 13.8
    }
    
    struct Scan {
        static let faceIDScanType = "Face ID"
    }
    
    struct UserDefaults {
        static let defaultOneOfOneBackendUrl = "https://@%.1of1eyewear.com/api/rest/v9/"
        static let defaultYoumawoBackendUrl = "https://@%.youmawo.com/youmawoWeb/rest/v7/"
        
        static let canUseVTO = "canUseVTO"
        static let isEndCustomer = "isEndCustomer"
        static let customBackendUrl = "customBackendUrl"
        static let password = "password"
        static let domain = "domain"
        static let environment = "environment"
        static let hideScannerControls = "hideScannerControls"
        static let displayLogger = "displayLogger"
        static let displayBackendSwitcher = "displayBackendSwitcher"
        
        static let usePortalCredential = "USE_PORTAL_CREDENTIAL"
        static let imagePrefetchingEnabled = "IMAGE_PREFETCHING_ENABLED"
        static let imagePrefetchingProductDetailViewEnabled = "IMAGE_PREFETCHING_PRODUCT_DETAILVIEW_ENABLED"
    }
    
    struct Localizable {
        struct ProductsCatalog {
            static let selectStatus = "products_catalog_select_status_title"
            static let new = "products_catalog_new"
            static let onSale = "products_catalog_on_sale"
            static let selectCollection = "products_catalog_select_collection_title"
            static let search = "products_catalog_search_title"
            static let emptyCell = "products_catalog_empty_cell_title"
        }
    }
}
