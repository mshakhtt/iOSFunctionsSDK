//
//  RestManager.swift
//  OneOfOne
//
//  Created by tsukat on 19.11.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import UIKit
import AFNetworking

public class RestManager {
    
    // MARK: - Constants
    
    private struct Constants {
        static let orderId = "orderId"
        static let scanType = "scanType"
        static let token = "token"
        static let email = "email"
        static let name = "name"
    }
    
    // MARK: - Properties
    
    private var userAgent: String?
    private var versionString: String?
    private var build: String?
    private var device: String?
    private var iosVersion: String?
    private let currentUser = UserManager.currentUser
    
    static let shared = RestManager()
    let userDefaults = UserDefaults.standard
    
    // MARK: - Methods
    
    func getBaseURL() -> String {
        return UserDefaults.standard.backendUrl ?? ""
    }
    
    func getUrl(withPath path: String) -> String? {
        let baseUrl = self.getBaseURL()
        let url = URL(string: baseUrl)?.appendingPathComponent(path)
        let urlString = url?.absoluteString
        return urlString
    }
    
    func order(_ orderResult: OrderResult, _ completionHandler: @escaping (Data?) -> Void) {
        guard let url = getUrl(withPath: ApiUrlSuffix.order) else {
            print("RestManager.order: error at getting url")
            completionHandler(nil)
            return
        }
        let session = URLSession.shared
        
        let order = Order(orderType: orderResult.orderType, name: orderResult.name, email: orderResult.email, phoneNumber: orderResult.phoneNumber, frameId: orderResult.frameId, colorId: orderResult.colorId, featureIds: orderResult.featureIds, comments: orderResult.comments, address: orderResult.address, customization: orderResult.customization)
        
        var request = URLRequest(url: URL(string: url)!)
        var params = [String: String]()
        
        if orderResult.token != "" {
            params[Constants.token] = orderResult.token
            
            var orderUrl = URLComponents(string: url)
            var queryItems = [URLQueryItem]()
            params.forEach({
                queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
            })
            
            orderUrl?.queryItems = queryItems
            guard let url = orderUrl?.url else {
                completionHandler(nil)
                return
            }
            request = URLRequest(url: url)
        }
        
        request.httpMethod = "POST"
        
        do {
            let jsonData = try JSONEncoder().encode(order)
            
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    print("\(#function) statusCode: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                        print("\(#function) order created")
                    } else {
                        completionHandler(nil)
                        return
                    }
                }
                
                guard error == nil else {
                    print("\(#function) response error: \(error?.localizedDescription)")
                    completionHandler(nil)
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil)
                    return
                }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                        completionHandler(nil)
                        return
                    }
                    print("\(#function) json: \(json)")
                    completionHandler(data)
                } catch let error {
                    print("\(#function) response error: \(error.localizedDescription)")
                    completionHandler(nil)
                }
            })
            
            task.resume()
        } catch {
            print("\(#function) response error: \(error.localizedDescription)")
        }
    }
    
    func attachScan(orderResult: OrderResult, orderId: String, completion: @escaping (Bool) -> Void) {
        guard let attachScanUrl = URL(string: userDefaults.backendUrl ?? "")?.appendingPathComponent(ApiUrlSuffix.attachScan) else {
            return
        }
        var params = [String: Any]()
        
        params[Constants.orderId] = orderResult.id
        params[Constants.scanType] = LocalConstants.Scan.faceIDScanType
        
        if currentUser?.access_token != "" {
            params[Constants.token] = currentUser?.access_token
        }
        params[Constants.orderId] = orderId
        
        let zipPart = MultipartFileData(fileData: orderResult.scan, name: "zipFile", fileName: "ZIP", mimeType: "application/octet-stream")
        let screenShotData = orderResult.screenShot
        
        if screenShotData.isEmpty {
            print("\(RestManager.self).\(#function) screenShotData ie empty")
        }
        
        let imagePart = MultipartFileData(fileData: screenShotData, name: "imageFile", fileName: "SCREENSHOT", mimeType: "application/octet-stream")
        let multiparts = [zipPart, imagePart]
        
        params[Constants.email] = orderResult.email
        params[Constants.name] = orderResult.name
        
        let serializer = AFHTTPRequestSerializer()
        let manager = AFHTTPSessionManager()
        
        manager.requestSerializer = serializer
        manager.responseSerializer.acceptableContentTypes?.removeAll(keepingCapacity: false)
        manager.responseSerializer.acceptableContentTypes?.insert("application/json")
        manager.post(attachScanUrl.absoluteString, parameters: params, headers: nil) { formData in
            multiparts.forEach({
                formData.appendPart(withFileData: $0.fileData, name: $0.name, fileName: $0.fileName, mimeType: $0.mimeType)
            })
        } progress: { progress in
            print("RestManager.attachScan scan to order with id \(orderId) progress \(progress.fractionCompleted)")
        } success: { dataTask, data in
            if let httpResponse = dataTask.response as? HTTPURLResponse {
                print("RestManager.attachScan success statusCode: \(httpResponse.statusCode)")
            } else {
                print("RestManager.attachScan success dataTask.response can't be casted to HTTPURLResponse")
            }
            completion(true)
        } failure: { dataTask, error in
            if let httpResponse = dataTask?.response as? HTTPURLResponse {
                print("RestManager.attachScan failure statusCode: \(httpResponse.statusCode)")
            } else {
                print("RestManager.attachScan failure dataTask.response can't be casted to HTTPURLResponse")
            }
            completion(false)
            print("RestManager.attachScan failure with error: \(error.localizedDescription)")
        }
        print("RestManager.attachScan: Going request HTTP POST: '\(attachScanUrl.absoluteString)' with parameters: '\(params)' - multiparts: '\(multiparts)'")
    }
    
    func attachPhoto(_ images: [UIImage]?, orderId: String?, index: Int, completion: @escaping (Bool) -> Void) {
        guard let attachPhotoUrl = URL(string: userDefaults.backendUrl ?? "")?.appendingPathComponent(ApiUrlSuffix.attachPhoto) else {
            return
        }
        
        let user = currentUser
        var params = [String: Any]()
        
        if user?.access_token != "" {
            params[Constants.token] = user?.access_token
        }
        params[Constants.orderId] = orderId
        
        var resultImage = UIImage()
        let img = images?[index]
        
        let rotatedImage = img?.rotateImageBy(90)
        if let rotatedImage = rotatedImage {
            resultImage = rotatedImage
        }
        
        let imageData = resultImage.jpegData(compressionQuality: 1) ?? Data()
        let picturePart = MultipartFileData(fileData: imageData, name: "picture", fileName: "PICTURE", mimeType: "application/octet-stream")
        
        var multiparts = [MultipartFileData]()
        multiparts.append(picturePart)
        
        let manager = AFHTTPSessionManager()
        let serializer = AFHTTPRequestSerializer()
        
        manager.requestSerializer = serializer
        manager.responseSerializer.acceptableContentTypes?.removeAll(keepingCapacity: false)
        manager.responseSerializer.acceptableContentTypes?.insert("application/json")
        manager.post(attachPhotoUrl.absoluteString, parameters: params, headers: nil) { formData in
            multiparts.forEach({
                formData.appendPart(withFileData: $0.fileData, name: $0.name, fileName: $0.fileName, mimeType: $0.mimeType)
            })
        } progress: { progress in
            print("RestManager.attachPhoto attaching photo #\(index) progress \(progress.fractionCompleted)")
        } success: { dataTask, data in
            completion(true)
        } failure: { dataTask, error in
            completion(false)
            print(error.localizedDescription)
        }
    }
    
    func attachScreenShot(_ imageData: Data?, orderId: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: userDefaults.backendUrl ?? "")?.appendingPathComponent(ApiUrlSuffix.attachPhoto) else {
            return
        }
        
        let user = currentUser
        var params = [String: Any]()
        
        if user?.access_token != "" {
            params[Constants.token] = user?.access_token
        }
        
        params[Constants.orderId] = orderId
        
        let picturePart = MultipartFileData(fileData: imageData, name: "picture", fileName: "PICTURE", mimeType: "application/octet-stream")
        
        var multiparts = [MultipartFileData]()
        multiparts.append(picturePart)
        
        let serializer = AFHTTPRequestSerializer()
        
        let manager = AFHTTPSessionManager()
        manager.requestSerializer = serializer
        manager.responseSerializer.acceptableContentTypes?.removeAll(keepingCapacity: false)
        manager.responseSerializer.acceptableContentTypes?.insert("application/json")
        manager.post(url.absoluteString, parameters: params, headers: nil) { formData in
            multiparts.forEach({
                formData.appendPart(withFileData: $0.fileData, name: $0.name, fileName: $0.fileName, mimeType: $0.mimeType)
            })
        } progress: { progress in
            print("RestManager.attachScreenShot: uploading attachScreenShot with id \(orderId) progress \(progress.fractionCompleted)")
        } success: { dataTask, data in
            completion(true)
        } failure: { dataTask, error in
            completion(false)
            print(error.localizedDescription)
        }
    }
    
    func closeOrder(_ orderId: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: userDefaults.backendUrl ?? "")?.appendingPathComponent(ApiUrlSuffix.closeOrder) else {
            return
        }
        
        let user = currentUser
        var params = [String: String]()
        
        if user?.access_token != "" {
            params[Constants.token] = user?.access_token
        }
        params[Constants.orderId] = orderId
        
        var closeOrderUrl = URLComponents(string: url.absoluteString)
        var queryItems = [URLQueryItem]()
        params.forEach ({
            queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        })
        
        closeOrderUrl?.queryItems = queryItems
        
        var request = URLRequest(url: (closeOrderUrl!.url)!)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(false)
            }
            completion(data != nil)
        }.resume()
    }
    
    func uploadScan(_ customerInformation: CustomerInformationViewModel, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: userDefaults.backendUrl ?? "")?.appendingPathComponent(ApiUrlSuffix.uploadScan) else {
            return
        }
        
        let user = currentUser
        var params = customerInformation.getParams(false)
        
        params[Constants.email] = customerInformation.email
        params[Constants.scanType] = LocalConstants.Scan.faceIDScanType
        
        if user?.access_token != "" {
            params[Constants.token] = user?.access_token
        }
        
        let zipPart = MultipartFileData(fileData: customerInformation.zipFileContent ?? Data(), name: "zipFile", fileName: "ZIP", mimeType: "application/octet-stream")
        let imagePart = MultipartFileData(fileData: customerInformation.screenshotFileContent, name: "imageFile",
                                          fileName: "SCREENSHOT", mimeType: "application/octet-stream")
        var multiparts = [zipPart, imagePart]
        
        var imgs: [UIImage] = []
        if let images = customerInformation.cameraViewModel?.images {
            for img in images {
                let rotatedImage = img.rotateImageBy(90)
                if let rotatedImage = rotatedImage {
                    imgs.append(rotatedImage)
                }
            }
        }
        
        let imagesData = imgs.map() { img in
            return (img.jpegData(compressionQuality: 1))!
        }
        
        let pictureParams = ["picture1", "picture2", "picture3", "picture4"]
        
        for i in 0 ..< imagesData.count {
            let picturePart = MultipartFileData(fileData: imagesData[i], name: pictureParams[i], fileName: "PICTURE", mimeType: "application/octet-stream")
            multiparts.append(picturePart)
        }
        
        let manager = AFHTTPSessionManager()
        let serializer = AFHTTPRequestSerializer()
        
        manager.requestSerializer = serializer
        
        manager.responseSerializer.acceptableContentTypes?.removeAll(keepingCapacity: false)
        manager.responseSerializer.acceptableContentTypes?.insert("application/json")
        manager.post(url.absoluteString, parameters: params, headers: nil) { formData in
            for part in multiparts {
                formData.appendPart(withFileData: part.fileData, name: part.name, fileName: part.fileName, mimeType: part.mimeType)
            }
        } progress: { progress in
            print("RestManager.uploadScan: uploading scan progress \(progress.fractionCompleted)")
        } success: { dataTask, data in
            completion(true)
        } failure: { dataTask, error in
            completion(false)
            print(error.localizedDescription)
        }
    }
}
