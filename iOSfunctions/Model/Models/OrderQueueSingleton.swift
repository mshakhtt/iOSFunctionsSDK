//
//  OrderQueueSingleton.swift
//  YOUMAWO
//
//  Created by Admin on 19.12.2020.
//  Copyright © 2020 YOUMAWO. All rights reserved.
//

import Foundation

struct OrderQueueSingleton {
    
    // MARK: - Properties
    
    static var shared = OrderQueueSingleton()

    var dataManager: DataManager?
    var loginManager: LoginManager?
    let savedOrdersFileName = "savedOrders"
    
    // MARK: - Methods
     
    func updateOrderScanUploadedBy(orderId: String) {
        var orders = getAllOrders()
        
        do {
            for i in 0 ..< orders.count {
                if orders[i].id == orderId {
                    orders[i].scanUploaded = true
                }
            }
            
            let jsonData = try JSONEncoder().encode(orders)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            DocumentDirectoryManager.save(text: jsonString, toDirectory: DocumentDirectoryManager.documentDirectory(), withFileName: savedOrdersFileName)
        } catch let err {
            print("\(#function) error : \(err.localizedDescription)")
        }
    }
    
    func updateOrderBy(orderId: String, newOrderId: String) {
        var orders = getAllOrders()
        
        do {
            for i in 0 ..< orders.count {
                if orders[i].id == orderId {
                    orders[i].id = newOrderId
                    orders[i].uploaded = true
                }
            }
            
            let jsonData = try JSONEncoder().encode(orders)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            DocumentDirectoryManager.save(text: jsonString, toDirectory: DocumentDirectoryManager.documentDirectory(), withFileName: savedOrdersFileName)
        } catch let err {
            print("\(#function) error : \(err.localizedDescription)")
        }
    }
    
    func updateOrderStatus(orderId: String, status: OrderQueueStatus) {
        var orders = getAllOrders()
        
        do {
            for i in 0 ..< orders.count {
                if orders[i].id == orderId {
                    orders[i].status = status
                    
                    if status == .queueError {
                        orders[i].uploaded = true
                        orders[i].scanUploaded = true
                    }
                }
            }
            
            let jsonData = try JSONEncoder().encode(orders)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            DocumentDirectoryManager.save(text: jsonString, toDirectory: DocumentDirectoryManager.documentDirectory(), withFileName: savedOrdersFileName)
        } catch let err {
            print("OrderQueueSingleton.updateOrder - error : \(err.localizedDescription)")
        }
    }

    func saveOrder(order: OrderResult) {
        var orders = getAllOrders()
        
        orders.append(order)
        
        do {
            let jsonData = try JSONEncoder().encode(orders)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            DocumentDirectoryManager.save(text: jsonString, toDirectory: DocumentDirectoryManager.documentDirectory(), withFileName: savedOrdersFileName)
        } catch let err {
            print("\(#function) can't save order error : \(err.localizedDescription)")
        }
    }
    
    func getAllOrders() -> [OrderResult] {
        var orders = [OrderResult]()
        
        do {
            guard let filePath = DocumentDirectoryManager.append(toPath: DocumentDirectoryManager.documentDirectory(), withPathComponent: savedOrdersFileName) else {
                return orders
            }
            let ordersData = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
            
            orders = try JSONDecoder().decode([OrderResult].self, from: ordersData)
        }  catch let err {
            print("\(#function) Error: \(err.localizedDescription)")
        }
        return orders
    }
    
    func removeAllOrders() {
        guard let filePathStr = DocumentDirectoryManager.append(toPath: DocumentDirectoryManager.documentDirectory(), withPathComponent: savedOrdersFileName) else {
            return
        }
        let filePath = URL(fileURLWithPath: filePathStr)
        
        try? FileManager.default.removeItem(at: filePath)
    }
}
