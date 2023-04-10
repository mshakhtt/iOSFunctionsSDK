//
//  RestClient.swift
//  YOUMAWO
//
//  Created by Admin on 8/9/19.
//  Copyright © 2019 YOUMAWO. All rights reserved.
//

import UIKit

public class RestClient: RestClientProtocol {
    
    private struct Constants {
        static let objectKey = "object"
        static let ordersLimitKey = "ordersLimit"
        static let ordersPlacedKey = "ordersPlaced"
        static let uRLQueryItemUsernameKey = "username"
        static let uRLQueryItemPasswordKey = "password"
        static let uRLQueryItemAppVersionKey = "appVersion"
        static let uRLQueryItemIpadVersionKey = "ipadVersion"
        static let uRLQueryItemIosVersionKey = "iosVersion"
    }
    
    // MARK: - Properties
    
    public typealias CompletionHandler = (_ success: CanUserCreateOrder) -> Void
    let userDefaults = UserDefaults.standard
    
    static var shared: RestClient {
        return RestClient()
    }
    
    // MARK: - Init
    
    init() {}
    
    // MARK: - Methods
    
    func checkIfUserCanCreateOrder(_ completionHandler: @escaping CompletionHandler) {
        guard let user = UserManager.currentUser else {
            completionHandler(.canNotCreate)
            return
        }
        
        guard let url = URL(string: userDefaults.backendUrl ?? "")?.appendingPathComponent(ApiUrlSuffix.ordersLimit) else {
            completionHandler(.canNotCreate)
            return
        }
        
        var myUrl = URLComponents(string: url.absoluteString)
        
        myUrl?.queryItems = [
            URLQueryItem(name: "token", value: user.access_token)
        ]
        
        let request = URLRequest(url: (myUrl?.url)!)
        
        if userDefaults.isUserLoggedIn() {
            if UserManager.currentUser?.isUserEndCustomer ?? false {
                let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                    guard error == nil else {
                        print("\(#function) error description \(error?.localizedDescription)")
                        completionHandler(.canNotCreate)
                        return
                    }
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] else {
                            return
                        }
                        
                        guard let jsonObject = json[Constants.objectKey] as? [String: AnyObject],
                              let ordersLimit = jsonObject[Constants.ordersLimitKey] as? Int,
                              let ordersPlaced = jsonObject[Constants.ordersPlacedKey] as? Int else {
                            print("\(#function) Can't parse json: \(json)")
                            return
                        }
                        
                        let orderLimit = OrdersLimit(ordersLimit: ordersLimit, ordersPlaced: ordersPlaced)
                        
                        if orderLimit.ordersLimit - orderLimit.ordersPlaced > 0 {
                            completionHandler(.canCreate)
                        } else {
                            completionHandler(.canNotCreate)
                        }
                    } catch {
                        completionHandler(.canNotCreate)
                        return
                    }
                }
                
                task.resume()
            } else {
                completionHandler(.canNotCreate)
            }
        } else {
            completionHandler(.canNotCreate)
        }
    }
    
    func getCanUseVTO(_ completionHandler: @escaping VTOHandler) {
        guard let user = UserManager.currentUser else {
            return
        }
        
        guard let url = URL(string: userDefaults.backendUrl ?? "")?.appendingPathComponent("scanningMethod") else {
            return
        }
        
        var myUrl = URLComponents(string: url.absoluteString)
        
        myUrl?.queryItems = [
            URLQueryItem(name: "token", value: user.access_token)
        ]
        
        let request = URLRequest(url: (myUrl?.url)!)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    if let jsonObject = json["object"] as? String {
                        completionHandler(.success(jsonObject))
                    }
                }
            } catch {
                completionHandler(.failure(error))
                return
            }
        }
        task.resume()
    }
    
    func getCountries(_ completionHandler: @escaping CountryHandler) {
        guard let path = Bundle.main.path(forResource: "countries", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let jsonObject = json["object"] as? Array<Any> else { return }
                let countries: [Country] = jsonObject.compactMap { dict in
                    guard let dict = dict as? [String: Any] else { return nil }
                    
                    let country = Country(dict)
                    return country
                }
                completionHandler(.success(countries))
                return
            } catch {
                completionHandler(.failure(error))
                return
            }
        } catch let err {
            print(err)
        }
    }
    
    func getCollections(_ completionHandler: @escaping Handler) {
        guard let path = Bundle.main.path(forResource: "products", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let jsonObject = json["object"] as? Array<Any> else { return }
                let collections: [Collection] = jsonObject.compactMap { dict in
                    guard let dict = dict as? [String: Any] else { return nil }
                    
                    let collection = Collection(dict)
                    return collection
                }
                
                completionHandler(.success(collections))
                return
            } catch {
                completionHandler(.failure(error))
                return
            }
        } catch let err {
            print(err)
        }
    }
    
    func login(userName: String, password: String, _ completionHandler: @escaping (Data?) -> Void) {
        guard let url = URL(string: userDefaults.backendUrl ?? "")?.appendingPathComponent(ApiUrlSuffix.authenticate) else {
            print("\(#function): Error getting url")
            return
        }
        
        var authenticateUrl = URLComponents(string: url.absoluteString)
        authenticateUrl!.queryItems = [
            URLQueryItem(name: Constants.uRLQueryItemUsernameKey, value: userName),
            URLQueryItem(name: Constants.uRLQueryItemPasswordKey, value: password),
            URLQueryItem(name: Constants.uRLQueryItemAppVersionKey, value: Bundle.applicationBuildNumber),
            URLQueryItem(name: Constants.uRLQueryItemIpadVersionKey, value: UIDevice.current.deviceModel),
            URLQueryItem(name: Constants.uRLQueryItemIosVersionKey, value: UIDevice.current.iosVersion)]
        
        var request = URLRequest(url: (authenticateUrl!.url)!)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("\(#function): RestClient.login: Error at getting response: \(error?.localizedDescription ?? "")")
                completionHandler(nil)
                return
            }
            
            guard let data = data else {
                print("\(#function): RestClient.login: error data is empty")
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
        task.resume()
    }
}
