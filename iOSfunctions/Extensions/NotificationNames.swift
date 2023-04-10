//
//  NotificationNames.swift
//  YOUMAWO
//
//  Created by Andreas Wörner on 11.08.18.
//  Copyright © 2018 YOUMAWO. All rights reserved.
//

public extension Notification.Name {
    static let openLookbook = Notification.Name("openLookbook")
    static let openURL = Notification.Name("openURL")
    static let showCollectionView = Notification.Name("showCollectionView")
    static let showLogin = Notification.Name("showLogin")
    static let showLogout = Notification.Name("showLogout")
    static let showMenu = Notification.Name("showMenu")
    static let showNewScanner = Notification.Name("showNewScanner")
    static let showInstructionalVideo = Notification.Name("showInstructionalVideo")
    static let showScanner = Notification.Name("showScanner")
    static let hideScanner = Notification.Name("hideScanner")
    static let showSettings = Notification.Name("showSettings")
    static let hideSettings = Notification.Name("hideSettings")
    static let showOrderQueue = Notification.Name("showOrderQueue")
    static let hideOrderQueue = Notification.Name("hideOrderQueue")
    static let updateLoginState = Notification.Name("updateLoginState")
    static let loadProductsCollection = Notification.Name("loadProductsCollection")
    static let loadVTOCollection = Notification.Name("loadVTOCollection")
    
    static let closeDownloaderNotification = Notification.Name("closeDownloaderNotification")
    static let updateLogo = Notification.Name("updateLogo")
    static let updateLayout = Notification.Name("updateLayout")
    static let updateWideCell = Notification.Name("updateWideCell")
    
    static let showVTOViewController = Notification.Name("showVTOViewController")
    
    static let uploadOrders = Notification.Name("uploadOrders")
    static let updateOrderQueueCollectionView = Notification.Name("updateOrderQueueCollectionView")
    static let startUploadOrderedItems = Notification.Name("startUploadOrderedItems")
    
    static let startCompatibilityCheck = Notification.Name("startCompatibilityCheck")
    static let startValidateSession = Notification.Name("startValidateSession")
    static let compatibilityChanged = Notification.Name("compatibilityChanged")
    static let showOrderLimitAlert = Notification.Name("showOrderLimitAlert")
    static let showBadInternetConnectionAlert = Notification.Name("showBadInternetConnectionAlert")
    static let showNoTrueDepthCameraAlert = Notification.Name("showNoTrueDepthCameraAlert")
    static let dismissLoadingView = Notification.Name("dismissLoadingView")
    
    static let collapseDrawer = Notification.Name("collapseDrawer")
    static let removeFromFavorites = Notification.Name("removeFromFavorites")
    static let removeFromFavoritesbyButton = Notification.Name("removeFromFavoritesbyButton")
    static let addToFavorites = Notification.Name("addToFavorites")
    static let reloadProductStoreData = Notification.Name("reloadProductStoreData")
    
    static let countrySelected = Notification.Name("countrySelected")
    static let countryCodeSelected = Notification.Name("countryCodeSelected")
    static let isFrameFromDetails = Notification.Name("isFrameFromDetails")
    
    static let removeLoaderView = Notification.Name("removeLoaderView")
    
    static let closeFilterView = Notification.Name("closeFilterView")
    static let filterCollections = Notification.Name("filterCollections")
    static let setSelectedFrameIndex = Notification.Name("setSelectedFrameIndex")
    
    static let showCustomizationViewFromDetailView = Notification.Name("showCustomizationViewFromDetailView")
    static let startLoadingFrameView = Notification.Name("startLoadingFrameView")
    static let destroyFrame = Notification.Name("destroyFrame")
    static let showBestSellers = Notification.Name("showBestSellers")
    static let updateOrderQueueButton = Notification.Name("updateOrderQueueButton")
    static let productsLoaded = Notification.Name("productsLoaded")
}
