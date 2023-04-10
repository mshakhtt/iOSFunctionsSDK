//
//  Model.swift
//  YOUMAWO
//
//  Created by Admin on 8/9/19.
//  Copyright © 2019 YOUMAWO. All rights reserved.
//

import UIKit

var isOrderQueueInProgress = false
var isFromOrderQueue = false
let compatibilityCheckTimePeriod: TimeInterval = 10

public class Model: NSObject, URLSessionDelegate {
    
    // MARK: - Properties
    
    var collectionsUpdated: Bool
    var productFamilyUpdated: Bool
    var productUpdated: Bool
    var colorsUpdated: Bool
    var imagesUpdated: Bool
    
    var indexFrame: Int
    var indexConfig: Int
    var indexTemple: Int
    var frames: [Frame]
    
    let loginManager = LoginManager.shared
    let userDefaults = UserDefaults.standard
    let restClient = RestClient()
    
    var uploadedItemsId: [String]
    var backgroundTaskID = UIBackgroundTaskIdentifier(rawValue: 4222)
    
    var orderRetry = 0
    var models: [OrderToUpload]
    var imagesViews: [UIImageView]
    var orders: [OrderResult]
    
    // MARK: - Init
    
    override init() {
        self.collectionsUpdated = false
        self.productFamilyUpdated = false
        self.productUpdated = false
        self.colorsUpdated = false
        self.imagesUpdated = false
        
        self.indexFrame = 1
        self.indexConfig = 1
        self.indexTemple = 1
        
        self.frames = [Frame]()
        
        self.uploadedItemsId = [String]()
        self.models = [OrderToUpload]()
        self.orders = [OrderResult]()
        self.imagesViews = [UIImageView]()
    }
    
    // MARK: - Methods
    
    func checkIfUserCanCreateOrder() {
        restClient.checkIfUserCanCreateOrder { (res) in
            Common.canUserCreateOrder = res
        }
    }
    
    // Start extra thread for regular compatibility checks.
    func runCompatibilityCheckerInBackground() {
        DispatchQueue.global().async {
            // Request the task assertion and save the ID.
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "com.OneOfOne.compatibilityChecker") {
                // End the task if time expires.
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: compatibilityCheckTimePeriod, repeats: true) { timer in
            print("Model.runCompatibilityCheckerInBackground: Update compatibility checker timer ran")
            NotificationCenter.default.post(name: .startCompatibilityCheck, object: nil)
            
            if self.userDefaults.isUserLoggedIn() {
                NotificationCenter.default.post(name: .startValidateSession, object: nil)
            }
        }
    }
    
    func runInBackground() {
        DispatchQueue.global().async {
            // Request the task assertion and save the ID.
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "com.OneOfOne.uploadOrders") {
                // End the task if time expires.
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("uploadOrders"), object: nil)
        }
    }
    
    // MARK: - uploadOrders
    
    @objc func uploadOrders(_ notification: NSNotification) {
        
        print("\(Model.self).\(#function) Trying to upload ordered items")
        
        self.models = [OrderToUpload]()
        self.uploadedItemsId.removeAll()
        
        orderRetry += 1
        
        let orders = OrderQueueSingleton.shared.getAllOrders()
        let notUploadedItems = orders.filter { !$0.uploaded || !$0.scanUploaded }
        
        for item in notUploadedItems {
            var orderCreated = false
            
            if item.id.contains("order-") {
                orderCreated = false
            } else {
                orderCreated = true
            }
            
            self.models.append(OrderToUpload(order: item, orderId: item.id, orderCreated: orderCreated, scanUploaded: item.scanUploaded, photosUploaded: true, type: "order"))
        }
        uploadItem(index: 0)
    }
    
    // MARK: - uploadItem
    
    func uploadItem(index: Int) {
        if isOrderQueueInProgress == true {
            print("Model.uploadItem: OrderQueueInProgress, please wait for completion")
        }
        
        if self.models.isEmpty {
            isOrderQueueInProgress = false
            print("\(Model.self).\(#function): models.isEmpty")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + LocalConstants.orderReuploadDelayInSec) {
                NotificationCenter.default.post(name: NSNotification.Name("uploadOrders"), object: nil)
            }
            return
        }
        
        if index == self.models.count {
            isOrderQueueInProgress = false
            print("Model.uploadItem: \(index) == \(models.count)")
            DispatchQueue.main.asyncAfter(deadline: .now() + LocalConstants.orderReuploadDelayInSec) {
                NotificationCenter.default.post(name: NSNotification.Name("uploadOrders"), object: nil)
            }
            return
        }
        
        let orderResult = self.models[index]
        
        DispatchQueue.main.async {
            print("Model.uploadItem: Upload items")
            
            let nextIndex = index + 1
            
            if self.uploadedItemsId.contains(orderResult.orderId) {
                print("Model.uploadItem: Items already uploaded to portal")
                DispatchQueue.main.asyncAfter(deadline: .now() + LocalConstants.orderReuploadDelayInSec) {
                    self.uploadItem(index: nextIndex)
                }
            } else {
                if orderResult.type == "order" {
                    print("!OrderQueue - uploading \(orderResult.orderId)")
                    OrderQueueSingleton.shared.updateOrderStatus(orderId: orderResult.orderId, status: .orderUploading)
                    
                    self.uploadedItemsId.append(orderResult.orderId)
                    isFromOrderQueue = true
                    
                    isOrderQueueInProgress = true
                    
                    OrderUploadManager.shared.uploadOrder(orderResult: orderResult.order) { (newOrderId, res) in
                        
                        if res {
                            print("Model.uploadItem: Order \(newOrderId) uploaded to the portal")
                            OrderQueueSingleton.shared.updateOrderStatus(orderId: newOrderId, status: .orderUploaded)
                        } else {
                            print("Model.uploadItem: Failed to upload \(newOrderId) to the portal")
                            OrderQueueSingleton.shared.updateOrderStatus(orderId: newOrderId, status: .queueError)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + LocalConstants.orderReuploadDelayInSec) {
                                self.uploadItem(index: nextIndex)
                            }
                            return
                        }
                        
                        if nextIndex < self.models.count - 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + LocalConstants.orderReuploadDelayInSec) {
                                self.uploadItem(index: nextIndex)
                            }
                            
                            if res {
                                isOrderQueueInProgress = false
                                print("Model.uploadItem: Order uploaded successfully with id \(newOrderId)")
                                OrderQueueSingleton.shared.updateOrderStatus(orderId: newOrderId, status: .orderUploaded)
                            } else {
                                isOrderQueueInProgress = false
                                print("Model.uploadItem: Error in upload order progress with id: \(newOrderId)")
                                OrderQueueSingleton.shared.updateOrderStatus(orderId: newOrderId, status: .queueError)
                            }
                        } else {
                            print("Model.uploadItem: There is nothing next to upload")
                            isOrderQueueInProgress = false
                            return
                        }
                    }
                    
                    OrderUploadManager.shared.uploadOrder(orderResult: orderResult.order) { (newOrderId, res) in
                        if res {
                            print("Model.uploadItem: Order \(newOrderId) uploaded to the portal")
                            OrderQueueSingleton.shared.updateOrderStatus(orderId: newOrderId, status: .orderUploaded)
                        } else {
                            print("Model.uploadItem: Failed to upload \(newOrderId) to the portal")
                            OrderQueueSingleton.shared.updateOrderStatus(orderId: newOrderId, status: .queueError)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + LocalConstants.orderReuploadDelayInSec) {
                                self.uploadItem(index: nextIndex)
                            }
                            return
                        }
                        
                        if nextIndex < self.models.count - 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + LocalConstants.orderReuploadDelayInSec) {
                                self.uploadItem(index: nextIndex)
                            }
                            
                            if res {
                                isOrderQueueInProgress = false
                                print("Model.uploadItem: Order uploaded successfully with id \(newOrderId)")
                                OrderQueueSingleton.shared.updateOrderStatus(orderId: newOrderId, status: .orderUploaded)
                            } else {
                                isOrderQueueInProgress = false
                                print("Model.uploadItem: Error in upload order progress")
                                OrderQueueSingleton.shared.updateOrderStatus(orderId: newOrderId, status: .queueError)
                            }
                        } else {
                            print("Model.uploadItem: There is nothing next to upload")
                            isOrderQueueInProgress = false
                            return
                        }
                    }
                }
            }
        }
    }
    
    @objc func updateOrderQueueCollectionView(_ notification: Notification) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadOrderQueueViewControllerData"), object: nil)
        }
    }
    
    @objc func removeObservers(_ notification: NSNotification) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(uploadOrders(_:)), name: NSNotification.Name("uploadOrders"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeObservers(_:)), name: NSNotification.Name("removeObservers"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderQueueCollectionView(_:)), name: NSNotification.Name("updateOrderQueueCollectionView"), object: nil)
    }
    
    func validateSession() {
        guard let user = UserManager.currentUser else {
            return
        }
        
        guard let url = URL(string: self.userDefaults.backendUrl ?? "")?.appendingPathComponent(ApiUrlSuffix.validateSession) else {
            return
        }
        
        var validateSessionUrl = URLComponents(string: url.absoluteString)
        validateSessionUrl!.queryItems = [URLQueryItem(name: "token", value: user.access_token)]
        
        let request = URLRequest(url: (validateSessionUrl!.url)!)
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.logOut()
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                self.loginManager.loginSessionValid()
            case 401:
                self.logOut()
            default:
                self.logOut()
            }
        }
        task.resume()
    }
    
    func logOut() {
        self.loginManager.logout()
        NotificationCenter.default.post(name: .showLogin, object: nil)
    }
    
    func checkCompatibility() {
        guard let user = UserManager.currentUser else {
            return
        }
        
        guard let url = URL(string: self.userDefaults.backendUrl ?? "")?.appendingPathComponent(ApiUrlSuffix.compatibility) else {
            return
        }
        
        var compatibilityUrl = URLComponents(string: url.absoluteString)
        
        compatibilityUrl!.queryItems = [
            URLQueryItem(name: "token", value: user.access_token),
            URLQueryItem(name: "appVersion", value: Bundle.applicationBuildNumber),
            URLQueryItem(name: "ipadVersion", value: UIDevice.current.deviceModel),
            URLQueryItem(name: "iosVersion", value: UIDevice.current.iosVersion)
        ]
        
        let request = URLRequest(url: (compatibilityUrl!.url)!)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject], let jsonObject = json["object"] as? [String: AnyObject] else { return }
                NotificationCenter.default.post(name: .compatibilityChanged, object: nil, userInfo: ["compatibility": Compatibility(jsonObject)])
            } catch {
                return
            }
        }
        task.resume()
    }
    
    func loadResources() {
        guard let user = UserManager.currentUser else {
            return
        }
        
        guard let url = URL(string: self.userDefaults.backendUrl ?? "")?.appendingPathComponent(ApiUrlSuffix.resources) else {
            return
        }
        
        var resourcesUrl = URLComponents(string: url.absoluteString)
        
        resourcesUrl!.queryItems = [URLQueryItem(name: "token", value: user.access_token)]
        
        let request = URLRequest(url: (resourcesUrl!.url)!)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                    if let jsonObject = json["object"] as? [String: AnyObject] {
                        let portal = jsonObject["portalURL"] as? String ?? ""
                        if (portal != "") {
                            PortalURL.shared.setUrlForPortalItem(url: portal)
                        }
                        
                        let catalogURL = jsonObject["catalogURL"] as? String ?? ""
                        if (catalogURL != "") {
                            PortalURL.shared.setUrlForCatalogItem(url: catalogURL)
                        }
                        
                        let newOrderURL = jsonObject["newOrderURL"] as? String ?? ""
                        if (newOrderURL != "") {
                            PortalURL.shared.setUrlForNewOrderItem(url: newOrderURL)
                        }
                        
                        let orderOverviewURL = jsonObject["orderOverviewURL"] as? String ?? ""
                        if (orderOverviewURL != "") {
                            PortalURL.shared.setUrlForOrderOverviewItem(url: orderOverviewURL)
                        }
                        
                        let scanOverviewURL = jsonObject["scanOverviewURL"] as? String ?? ""
                        if (scanOverviewURL != "") {
                            PortalURL.shared.setUrlForScanOverviewItem(url: scanOverviewURL)
                        }
                        
                        let findAStoreURL = jsonObject["findAStoreURL"] as? String ?? ""
                        if (findAStoreURL != "") {
                            PortalURL.shared.setUrlForFindAStoreItem(url: findAStoreURL)
                        }
                        
                        let aboutTheProductURL = jsonObject["aboutTheProductURL"] as? String ?? ""
                        if (aboutTheProductURL != "") {
                            PortalURL.shared.setUrlForAboutTheProductyItem(url: aboutTheProductURL)
                        }
                        
                        let ourStoryURL = jsonObject["ourStoryURL"] as? String ?? ""
                        if (ourStoryURL != "") {
                            PortalURL.shared.setUrlForOurStoryItem(url: ourStoryURL)
                        }
                        
                        let lookBookURL = jsonObject["lookBookURL"] as? String ?? ""
                        if (lookBookURL != "") {
                            PortalURL.shared.setUrlForLookBookItem(url: lookBookURL)
                        }
                        
                        let newsURL = jsonObject["newsURL"] as? String ?? ""
                        if (newsURL != "") {
                            PortalURL.shared.setUrlForNewsItem(url: newsURL)
                        }
                        
                        let termsURL = jsonObject["termsURL"] as? String ?? ""
                        if (termsURL != "") {
                            PortalURL.shared.setUrlForTermsItem(url: termsURL)
                        }
                        
                        let policyURL = jsonObject["policyURL"] as? String ?? ""
                        if (policyURL != "") {
                            PortalURL.shared.setUrlForPolicyItem(url: policyURL)
                        }
                        
                        let parameterInfoURL = jsonObject["parameterInfoURL"] as? String ?? ""
                        if (parameterInfoURL != "") {
                            
                        }
                        
                        let anonimusToken = jsonObject["anonymousToken"] as? String ?? ""
                        if (anonimusToken != "") {
                            self.loginManager.setAnonimusToken(anonimusToken: anonimusToken)
                        }
                    }
                }
            } catch {
                return
            }
        }
        task.resume()
    }
}
