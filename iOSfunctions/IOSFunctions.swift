//
//  IOSFunctions.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 27.03.2023.
//

import Foundation
import SharedWebCredentials

public class IOSFunctions {
    
    // MARK: - Properties
    
    public var productColor: ProductColor!
    public var cameraViewModel = CameraViewModel()
    public var customerInformationViewModel = CustomerInformationViewModel()
    public var productCatalogDetailViewModel: ProductCatalogDetailViewModel?
    public var orderInformationViewModel: OrderInformationViewModel?
    public var VTOViewModel: VTOViewModel?
    public var clientPrices: ClientPrices?
    public var typeClass: TypeClass?
    public var localSettings: LocalSettings?
    public var model: Model?
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - DataManager
    
    public func getCollectionList() -> [String] {
        DataManager.shared.collectionList
    }
    
    // MARK: - ConnectionManager
    
    public func getConnection() -> Bool {
        ConnectionManager.shared.getConnection()
    }
    
    public func isLoggedIn() -> Bool {
        return LoginManager.shared.isUserLoggedIn
    }
    
    // MARK: - LoginManager
    
    public func isUserEndCustomer() -> Bool {
        LoginManager.shared.isUserEndCustomer
    }
    
    public func isUserAllowedToUseVTO() -> Bool {
        LoginManager.shared.isUserAllowedToUseVTO
    }
    
    public func isPersonalFitPlusAllowed() -> Bool {
        LoginManager.shared.isPersonalFitPlusAllowed
    }
    
    public func isCustomLightAllowed() -> Bool {
        LoginManager.shared.isCustomLightAllowed
    }
    
    public func logout() {
        LoginManager.shared.logout()
    }
    
    public func login(userName: String, password: String, domain: String, environment: String, completion: @escaping (LoginStatus) -> Void) {
        LoginManager.shared.login(userName: userName, password: password, domain: domain, environment: environment) { result in
            completion(result)
        }
    }
    
    public func retrieveStoredCredentials() -> SharedWebCredentials.Credential? {
        LoginManager.shared.retrieveStoredCredentials()
    }
    
    // MARK: - UserManager
    
    class public var token: String {
        UserManager.token
    }
    
    class public var userName: String {
        UserManager.userName
    }
    
    class public var anonymusToken: String {
        UserManager.anonymusToken
    }
    
    class public var isUserEndCustomer: Bool {
        UserManager.isUserEndCustomer
    }
    
    class public var isUserAllowedToUseVTO: Bool {
        UserManager.isUserAllowedToUseVTO
    }
    
    class public var isPersonalFitPlusAllowed: Bool {
        UserManager.isPersonalFitPlusAllowed
    }
    
    class public var isCustomLightAllowed: Bool {
        UserManager.isCustomLightAllowed
    }
    
    class public var currentUser: MOProfile? {
        UserManager.currentUser
    }
    
    class public func setCurrentUser(newCurrentUser: MOProfile?) {
        UserManager.setCurrentUser(newCurrentUser: newCurrentUser)
    }
    
    class internal func saveCurrentUser() {
        UserManager.saveCurrentUser()
    }
    
    class internal func logOutCurrentUser() {
        UserManager.logOutCurrentUser()
    }
    
    class internal func logOutUserAndClearToken() {
        UserManager.logOutUserAndClearToken()
    }
    
    class internal func isLoggedIn() -> Bool {
        UserManager.isLoggedIn()
    }
    
    class internal func setToken(token: String) {
        UserManager.setToken(token: token)
    }
    
    class internal func setAnonymusToken(anonymusToken: String) {
        UserManager.setAnonymusToken(anonymusToken: anonymusToken)
    }
    
    class internal func setUserName(userName: String) {
        UserManager.setUserName(userName: userName)
    }
    
    class internal func setIsUserAllowedToUseVTO(isUserAllowedToUseVTO: Bool) {
        UserManager.setIsUserAllowedToUseVTO(isUserAllowedToUseVTO: isUserAllowedToUseVTO)
    }
    
    class internal func setIsPersonalFitPlusAllowed(isPersonalFitPlusAllowed: Bool) {
        UserManager.setIsPersonalFitPlusAllowed(isPersonalFitPlusAllowed: isPersonalFitPlusAllowed)
    }
    
    class internal func setIsCustomLightAllowed(isCustomLightAllowed: Bool) {
        UserManager.setIsCustomLightAllowed(isCustomLightAllowed: isCustomLightAllowed)
    }
    
    class internal func setIsUserEndCustomer(isEndCustomer: Bool) {
        UserManager.setIsUserEndCustomer(isEndCustomer: isEndCustomer)
    }
    
    class internal func pathWithObjectType(objectType: String) -> String {
        UserManager.pathWithObjectType(objectType: objectType)
    }
    
    // MARK: - Localization
    
    public func getCurrentLanguageName() -> String {
        Localization.shared.getCurrentLanguageName()
    }
    
    public func getLocalizedString(forKey key: String?) -> String? {
        Localization.shared.getLocalizedString(forKey: key)
    }
    
    // MARK: - CollectionsSingleton
    
    public func getIndexInFavoritesByProduct(product: Product) -> Int {
        CollectionsSingleton.shared.getIndexInFavoritesByProduct(product: product)
    }
    
    public func getFeatureColors(product: Product, type: String) -> [ProductColor] {
        CollectionsSingleton.shared.getFeatureColors(product: product, type: type)
    }
    
    public func saveFavoritesFrames(products: [Product], functionName: String) {
        CollectionsSingleton.shared.saveFavoritesFrames(products: products, functionName: functionName)
    }
    
    public func getFavoritesFrames() -> [Product] {
        CollectionsSingleton.shared.getFavoritesFrames()
    }
    
    public func removeFavoritesFrames() {
        CollectionsSingleton.shared.removeFavoritesFrames()
    }
    
    public func getDefaultFrameMaterialFeatureId(product: Product) -> Int {
        CollectionsSingleton.shared.getDefaultFrameMaterialFeatureId(product: product)
    }
    
    public func getDefaultFrameSizeFeatureId(product: Product) -> Int {
        CollectionsSingleton.shared.getDefaultFrameSizeFeatureId(product: product)
    }
    
    public func loadCountries(_ completionHandler: @escaping CollectionsSingleton.CompletionHandler) {
        CollectionsSingleton.shared.loadCountries { success in
            completionHandler(success)
        }
    }
    
    public func loadCollectionsData(_ completionHandler: @escaping CollectionsSingleton.CompletionHandler) {
        CollectionsSingleton.shared.loadCollectionsData { success in
            completionHandler(success)
        }
    }
    
    public func filterCollections(_ collections: [Collection]) -> [Collection] {
        CollectionsSingleton.shared.filterCollections(collections)
    }
    
    public func getCountries() -> [Country] {
        CollectionsSingleton.shared.getCountries()
    }
    
    public func getCollections() -> [Collection] {
        CollectionsSingleton.shared.getCollections()
    }
    
    public func getBestSellers(collections: [Collection]) -> [Product] {
        CollectionsSingleton.shared.getBestSellers(collections: collections)
    }
    
    public func getVTOCollections() -> [Collection] {
        CollectionsSingleton.shared.getVTOCollections()
    }
    
    public func getTempleBase64By(product: Product) -> String {
        CollectionsSingleton.shared.getTempleBase64By(product: product)
    }
    
    public func getFullFrameBase64By(product: Product) -> FullFrame {
        CollectionsSingleton.shared.getFullFrameBase64By(product: product)
    }
    
    public func setAnoimusToken(anonimusToken: String) {
        CollectionsSingleton.shared.setAnoimusToken(anonimusToken: anonimusToken)
    }
    
    // MARK: - RestClient
    
    public func checkIfUserCanCreateOrder(_ completionHandler: @escaping RestClient.CompletionHandler) {
        RestClient.shared.checkIfUserCanCreateOrder { success in
            completionHandler(success)
        }
    }
    
    // MARK: - RestManager
    
    public func getUrl(withPath path: String) -> String? {
        RestManager.shared.getUrl(withPath: path)
    }
    
    public func order(_ orderResult: OrderResult, _ completionHandler: @escaping (Data?) -> Void) {
        RestManager.shared.order(orderResult) { result in
            completionHandler(result)
        }
    }
    
    public func attachScan(orderResult: OrderResult, orderId: String, completion: @escaping (Bool) -> Void) {
        RestManager.shared.attachScan(orderResult: orderResult, orderId: orderId) { result in
            completion(result)
        }
    }
    
    public func attachPhoto(_ images: [UIImage]?, orderId: String?, index: Int, completion: @escaping (Bool) -> Void) {
        RestManager.shared.attachPhoto(images, orderId: orderId, index: index) { result in
            completion(result)
        }
    }
    
    public func attachScreenShot(_ imageData: Data?, orderId: String, completion: @escaping (Bool) -> Void) {
        RestManager.shared.attachScreenShot(imageData, orderId: orderId) { result in
            completion(result)
        }
    }
    
    public func closeOrder(_ orderId: String, completion: @escaping (Bool) -> Void) {
        RestManager.shared.closeOrder(orderId) { result in
            completion(result)
        }
    }
    
    public func uploadScan(_ customerInformation: CustomerInformationViewModel, completion: @escaping (Bool) -> Void) {
        RestManager.shared.uploadScan(customerInformation) { result in
            completion(result)
        }
    }
    
    // MARK: - Common
    
    public class func isPad() -> Bool {
        Common.isPad()
    }
    
    public class func isOptician() -> Bool {
        Common.isOptician()
    }
    
    public static var canUserCreateOrder: CanUserCreateOrder {
        Common.canUserCreateOrder
    }
    
    public var filterParameters: FilterParameters = FilterParameters()
    
    // MARK: - Languages
    
    public func abbreviation(language: Languages) -> String {
        language.abbreviation()
    }
    
    public func vto(language: Languages) -> String {
        language.vto()
    }
    
    // MARK: - ProductCatalogDetailViewModel
    
    public func initProductCatalogDetailViewModel(product: Product, dataManager: DataManager, loginManager: LoginManager, vtoViewModel: VTOViewModel) {
        productCatalogDetailViewModel = ProductCatalogDetailViewModel(product: product, dataManager: dataManager, loginManager: loginManager, vtoViewModel: vtoViewModel)
    }
    
    // MARK: - OrderInformationViewModel
    
    public func initOrderInformationViewModel(customerInformationViewModel: CustomerInformationViewModel) {
        orderInformationViewModel = OrderInformationViewModel(customerInformationViewModel: customerInformationViewModel)
    }
}
