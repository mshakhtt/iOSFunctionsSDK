//
//  OrderUploadManager.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 23.03.2023.
//

import Foundation

public class OrderUploadManager {
    
    // MARK: - Properties
    
    public static let shared = OrderUploadManager()
    
    // MARK: - Methods
    
    func uploadOrder(orderResult: OrderResult, _ completion: @escaping (String, Bool) -> Void) {
        var orderId = orderResult.id
        if !orderResult.uploaded {
            RestManager.shared.order(orderResult) { data in
                do {
                    guard let data = data else {
                        print("\(#function) order data is empty")
                        completion(orderId, false)
                        return
                    }
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                        guard let newOrderId = json["object"] as? String else {
                            print("\(#function) Error getting json while uploading order: \(json)")
                            completion(orderId, false)
                            return
                        }
                        orderId = newOrderId
                        
                        if orderId == "" || orderId == " " {
                            orderId = orderResult.id
                        }
                        OrderQueueSingleton.shared.updateOrderBy(orderId: orderResult.id, newOrderId: orderId)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.attachScan(orderResult: orderResult, orderId: orderId) { result in
                                if result {
                                    OrderQueueSingleton.shared.updateOrderScanUploadedBy(orderId: orderId)
                                    self.closeOrder(orderId) { result in
                                        completion(orderId, result)
                                    }
                                } else {
                                    NotificationCenter.default.post(name: .uploadOrders, object: nil)
                                    completion(orderId, result)
                                }
                            }
                        }
                    }
                }
                catch let error {
                    print("\(#function) error: Order with id \(orderId) is not uploaded by reason \(error.localizedDescription)")
                    NotificationCenter.default.post(name: .uploadOrders, object: nil)
                    completion(orderId, false)
                }
            }
        } else {
            if !orderResult.scanUploaded {
                attachScan(orderResult: orderResult, orderId: orderId) { result in
                    if result {
                        OrderQueueSingleton.shared.updateOrderScanUploadedBy(orderId: orderId)
                        self.closeOrder(orderId) { result in
                            completion(orderId, result)
                        }
                    } else {
                        NotificationCenter.default.post(name: .uploadOrders, object: nil)
                        completion(orderId, result)
                    }
                }
            }
        }
    }
    
    func attachScan(orderResult: OrderResult, orderId: String, completion: @escaping (Bool) -> Void) {
        RestManager.shared.attachScan(orderResult: orderResult, orderId: orderId) { result in
            if result {
                OrderQueueSingleton.shared.updateOrderScanUploadedBy(orderId: orderId)
                completion(result)
            } else {
                NotificationCenter.default.post(name: .uploadOrders, object: nil)
                completion(result)
            }
        }
    }
    
    func closeOrder(_ orderId: String, completion: @escaping (Bool) -> Void) {
        RestManager.shared.closeOrder(orderId) { data in
            OrderQueueSingleton.shared.updateOrderScanUploadedBy(orderId: orderId)
            NotificationCenter.default.post(name: .updateOrderQueueCollectionView, object: nil)
            NotificationCenter.default.post(name: .uploadOrders, object: nil)
            print("\(#function) info: close order with order id \(orderId)")
            completion(true)
        }
    }
}
