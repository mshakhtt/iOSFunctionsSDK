//
//  UserDefaults+Extension.swift
//  OneOfOne
//
//  Created by mshakh on 07.12.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

public extension UserDefaults {
    
    // MARK: Functions
    
    func registerFromSettingsBundle() {
        // this function writes default settings as settings
        let settingsBundle = Bundle.main.path(forResource: "Settings", ofType: "bundle")
        if settingsBundle == nil {
            print("Could not find Settings.bundle")
            return
        }
        
        let settings = NSDictionary(contentsOfFile: URL(fileURLWithPath: settingsBundle ?? "").appendingPathComponent("Root.plist").path) as Dictionary?
        let preferences = settings?["PreferenceSpecifiers" as NSObject] as? [AnyHashable]
        
        var defaultsToRegister = [AnyHashable : Any](minimumCapacity: (preferences?.count ?? 0))
        for prefSpecification in preferences ?? [] {
            guard let prefSpecification = prefSpecification as? [AnyHashable : Any] else {
                continue
            }
            let key = prefSpecification["Key"] as? String
            if key != nil && object(forKey: key ?? "") == nil {
                defaultsToRegister[key] = prefSpecification["DefaultValue"]
                if let object = prefSpecification["DefaultValue"] {
                    print("writing as default \(object) to the key \(key ?? "")")
                }
            }
        }
        
        if let defaultsToRegister = defaultsToRegister as? [String : Any] {
            register(defaults: defaultsToRegister)
        }
        synchronize()
    }
    
    func clearUserInfo() {
        let keys = ["name", "email", "birthDate", "genderIndex", "shippingName", "address1", "address2", "postalCode", "city", "country"]
        for key in keys {
            removeObject(forKey: key)
        }
        self.synchronize()
    }
    
    func isUserLoggedIn() -> Bool {
        //print("User logged in -", UserManager.currentUser != nil)
        return UserManager.currentUser != nil
    }
    
    func isBackendSwither() -> Bool {
        return self.displayBackendSwitcher
    }
    
    func isDisplayLogger() -> Bool {
        return self.displayLogger
    }
    
    // MARK: Values
    
    var hideScannerControls: Bool {
        get {
            if self.object(forKey: LocalConstants.UserDefaults.hideScannerControls) == nil {
                self.hideScannerControls = true
            }
            return bool(forKey: LocalConstants.UserDefaults.hideScannerControls)
        }
        set {
            self.set(newValue, forKey: LocalConstants.UserDefaults.hideScannerControls)
            self.synchronize()
        }
    }
    
    var password: String {
        get {
            return string(forKey: LocalConstants.UserDefaults.password) ?? ""
        }
        set {
            if newValue != "" {
                removeObject(forKey: LocalConstants.UserDefaults.password)
            } else {
                self.set(newValue, forKey: LocalConstants.UserDefaults.password)
            }
            self.synchronize()
        }
    }
    
    var environment: String {
        get {
            return string(forKey: LocalConstants.UserDefaults.environment) ?? "portal"
        } set {
            self.set(newValue, forKey: LocalConstants.UserDefaults.environment)
            self.synchronize()
        }
    }
    
    var domain: String {
        get {
            return string(forKey: LocalConstants.UserDefaults.domain) ?? "test-light"
        }
        set {
            self.set(newValue, forKey: LocalConstants.UserDefaults.domain)
            self.synchronize()
        }
    }
    
    private func getYoumawoBaseURL() -> String {
        if self.environment.isEmpty {
            self.environment = "portal"
        }
        
        let url = "https://\(self.environment).youmawo.com/youmawoWeb/rest/v7/"
        
        self.backendUrl = url
        return url
    }
    
    private func getOneOfOneBaseURL() -> String {
        if self.domain.isEmpty {
            self.domain = "test-light"
        }
        
        let url = "https://\(self.domain).1of1eyewear.com/api/rest/v9/"
        self.backendUrl = url
        return url
    }
    
    var backendUrl: String? {
        get {
            var backendUrl = ""
            if !self.domain.isEmpty {
                backendUrl = self.getOneOfOneBaseURL()
            } else {
                backendUrl = self.getYoumawoBaseURL()
            }
            return backendUrl
        }
        set {
            self.set(newValue, forKey: LocalConstants.UserDefaults.customBackendUrl)
            self.synchronize()
        }
    }
    
    var displayLogger: Bool {
        get {
            if self.object(forKey: LocalConstants.UserDefaults.displayLogger) == nil {
                self.displayLogger = true
            }
            return bool(forKey: LocalConstants.UserDefaults.displayLogger)
        }
        set {
            self.set(newValue, forKey: LocalConstants.UserDefaults.displayLogger)
            self.synchronize()
        }
    }
    
    var displayBackendSwitcher: Bool {
        get {
            if self.object(forKey: LocalConstants.UserDefaults.displayBackendSwitcher) == nil {
                self.displayBackendSwitcher = true
            }
            return bool(forKey: LocalConstants.UserDefaults.displayBackendSwitcher)
        }
        set {
            self.set(newValue, forKey: LocalConstants.UserDefaults.displayBackendSwitcher)
            self.synchronize()
        }
    }
    
    var isEndCustomer: Bool {
        get {
            if self.object(forKey: LocalConstants.UserDefaults.isEndCustomer) == nil {
                self.isEndCustomer = true
            }
            return bool(forKey: LocalConstants.UserDefaults.isEndCustomer)
        }
        set {
            self.set(newValue, forKey: LocalConstants.UserDefaults.isEndCustomer)
            self.synchronize()
        }
    }
    
    var canUseVTO: Bool {
        get {
            if self.object(forKey: LocalConstants.UserDefaults.canUseVTO) == nil {
                self.canUseVTO = false
            }
            return bool(forKey: LocalConstants.UserDefaults.canUseVTO)
        }
        set {
            self.set(newValue, forKey: LocalConstants.UserDefaults.canUseVTO)
            self.synchronize()
        }
    }
    
     var usePortalCredential: Bool {
        get {
            #if DEVELOP || BETA
                return bool(forKey: LocalConstants.UserDefaults.usePortalCredential)
            #else
                return false
            #endif
        }
    }
    
    var isImagePrefetchingEnabled: Bool {
        get {
            #if DEVELOP || BETA
                return bool(forKey: LocalConstants.UserDefaults.imagePrefetchingEnabled)
            #else
                return false
            #endif
        }
    }
    
    var isImagePrefetchingProductDetailViewEnabled: Bool {
        get {
            #if DEVELOP || BETA
                return bool(forKey: LocalConstants.UserDefaults.imagePrefetchingProductDetailViewEnabled)
            #else
                return false
            #endif
        }
    }
}
