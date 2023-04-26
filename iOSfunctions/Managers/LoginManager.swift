//
//  LoginManager.swift
//  YOUMAWO
//
//  Created by Andreas Wörner on 21.10.18.
//  Copyright © 2018 YOUMAWO. All rights reserved.
//

import Foundation
import SharedWebCredentials

public class LoginManager: NSObject {
    
    // MARK: - Properties
    
    private var associatedDomain: String {
        return UserDefaults.standard.usePortalCredential ? "portal.youmawo.com" : "www.youmawo.com"
    }
    
    static let shared = LoginManager()
    
    let restClient = RestClient()
    var loginStatus: LoginStatus = .none
    
    var isUserLoggedIn: Bool {
        return UserManager.currentUser != nil ? true : false
    }
    
    var hasUser: Bool {
        return UserManager.currentUser != nil ? true : false
    }
    
    var isUserEndCustomer: Bool {
        return UserManager.currentUser?.isUserEndCustomer ?? false
    }
    
    var isUserAllowedToUseVTO: Bool {
        return UserManager.currentUser?.isUserAllowedToUseVTO ?? false
    }
    
    var isPersonalFitPlusAllowed: Bool {
        get {
            return UserManager.currentUser?.isPersonalFitPlusAllowed ?? false
        }
        set {
            UserManager.currentUser?.isPersonalFitPlusAllowed = newValue
        }
    }
    
    var isCustomLightAllowed: Bool {
        get {
            return UserManager.currentUser?.isCustomLightAllowed ?? false
        }
        set {
            UserManager.currentUser?.isCustomLightAllowed = newValue
        }
    }
    
    // MARK: - Methods
    
    class func sharedLoginManager() -> LoginManager {
        return LoginManager.shared
    }
    
    func loginSessionValid() {
        self.loginStatus = .success
    }
    
    func logout() {
        UserDefaults.standard.clearUserInfo()
        UserManager.logOutCurrentUser()
        loginStatus = .none
    }
    
    func setAnonimusToken(anonimusToken: String) {
        CollectionsSingleton.shared.setAnoimusToken(anonimusToken: anonimusToken)
    }
    
    func login(userName: String, password: String, domain: String, environment: String, completion: @escaping (LoginStatus) -> Void) {
        UserDefaults.standard.domain = domain
        UserDefaults.standard.environment = environment
        UserDefaults.standard.synchronize()
        
        restClient.login(userName: userName, password: password) { data in
            self.loginStatus = .progress
            var loginResult = false
            
            guard let data = data else {
                print("\(#function). LoginManager.login error: Login data is nil")
                self.loginStatus = .failed
                completion(self.loginStatus)
                return
            }
            
            loginResult = self.validateLoginResult(data: data)
            
            if loginResult {
                //      Store.add(domain: self.associatedDomain, account: userName, password: password, completion: { (error) in })
                CollectionsSingleton.shared.loadCollectionsData { _ in
                    NotificationCenter.default.post(name: .productsLoaded, object: nil)
                }
            }
            self.loginStatus = loginResult ? .success : .failed
            completion(self.loginStatus)
        }
    }
    
//    func retrieveStoredCredentials() -> SharedWebCredentials.Credential? {
//        var storedCredential: SharedWebCredentials.Credential?
//        Store.get { (credential, error) in
//            guard let credential = credential else { return }
//            storedCredential = credential
//        }
//        return storedCredential
//    }
    
    private func validateLoginResult(data: Data) -> Bool {
        let endCustomerRole = "end_customer"
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                guard let authenticated = json["authenticated"] as? String,
                      let token = json["token"] as? String,
                      let userName = json["user"] as? String,
                      let roles = json["roles"] as? [[String: AnyObject]],
                      let roleName = roles.first?["rolename"] as? String
                else {
                    return false
                }
                
                if (authenticated == "true") {
                    let profileModel: MOProfile = MOProfile(token: token,
                                                            userName: userName,
                                                            isUserEndCustomer: roleName == endCustomerRole,
                                                            isUserAllowedToUseVTO: isUserAllowedToUseVTO,
                                                            isPersonalFitPlusAllowed: isPersonalFitPlusAllowed,
                                                            isCustomLightAllowed: isCustomLightAllowed)
                    UserManager.setCurrentUser(newCurrentUser: profileModel)
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
