//
//  UserManager.swift
//  OneOfOne
//
//  Created by Admin on 07.12.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

public class UserManager: NSObject {
    
    // MARK: - Properties
    
    static let userType: String = "userProfile"
    static let UserManagerUserName: String = "UserManagerUserName"
    static let UserManagerUserToken: String = "UserManagerUserToken"
    static let UserManagerUserAnonymusToken: String = "UserManagerUserAnonymusToken"
    static let UserManagerIsEndCustomerUser: String = "UserManagerIsEndCustomerUser"
    static let UserManagerIsUserAllowedToUseVTO: String = "UserManagerIsUserAllowedToUseVTO"
    static let UserManagerIsPersonalFitPlusAllowed: String = "UserManagerIsPersonalFitPlusAllowed"
    static let UserManagerIsCustomLightAllowed: String = "UserManagerIsCustomLightAllowed"
    
    static var _currentUser: MOProfile?
    
    static var _token: String?
    static var _userName: String?
    static var _anonymusToken: String?
    static var _isEndCustomerUser: Bool?
    static var _isUserAllowedToUseVTO: Bool?
    static var _isPersonalFitPlusAllowed: Bool?
    static var _isCustomLightAllowed: Bool?
    
    class var token: String {
        get {
            return UserDefaults.standard.string(forKey: UserManager.UserManagerUserToken)!
        }
        set {
            UserManager.setToken(token: newValue)
        }
    }
    
    class var userName: String {
        get {
            return UserDefaults.standard.string(forKey: UserManager.UserManagerUserName)!
        }
        set {
            UserManager.setUserName(userName: newValue)
        }
    }
    
    class var anonymusToken: String {
        get {
            return UserDefaults.standard.string(forKey: UserManager.UserManagerUserAnonymusToken)!
        }
        set {
            UserManager.setAnonymusToken(anonymusToken: newValue)
        }
    }
    
    class var isUserEndCustomer: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserManager.UserManagerIsEndCustomerUser)
        }
        set {
            UserManager.setIsUserEndCustomer(isEndCustomer: newValue)
        }
    }
    
    class var isUserAllowedToUseVTO: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserManager.UserManagerIsUserAllowedToUseVTO)
        }
        set {
            UserManager.setIsUserAllowedToUseVTO(isUserAllowedToUseVTO: newValue)
        }
    }
    
    class var isPersonalFitPlusAllowed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserManager.UserManagerIsPersonalFitPlusAllowed)
        }
        set {
            UserManager.setIsPersonalFitPlusAllowed(isPersonalFitPlusAllowed: newValue)
        }
    }
    
    class var isCustomLightAllowed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserManager.UserManagerIsCustomLightAllowed)
        }
        set {
            UserManager.setIsCustomLightAllowed(isCustomLightAllowed: newValue)
        }
    }
    
    class var currentUser: MOProfile? {
        set {
            UserManager.setCurrentUser(newCurrentUser: newValue)
        }
        get {
            if (_currentUser != nil) {
                return _currentUser
            }
            let dataCurrentUser: NSData! = NSData(contentsOfFile: UserManager.pathWithObjectType(objectType: UserManager.userType))
            if (dataCurrentUser == nil) {
                return nil
            }
            
            do {
                _currentUser = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataCurrentUser as Data) as? MOProfile
            } catch {
                logOutCurrentUser()
            }
            return _currentUser
        }
    }
    
    // MARK: - Init
    
    override init() {}
    
    // MARK: - Methods
    
    class func setCurrentUser(newCurrentUser: MOProfile?) {
        _currentUser = newCurrentUser
        UserManager.saveCurrentUser()
    }
    
    class internal func saveCurrentUser() {
        if _currentUser == nil {
            print("Error! Save current user: currentUser == nil!!")
            return
        }
        let path: String = UserManager.pathWithObjectType(objectType: UserManager.userType)
        let fileManager: FileManager = FileManager.default
        
        print("PATH: \n%@", path)
        do {
            if fileManager.fileExists(atPath: path) {
                try fileManager.removeItem(atPath: path as String)
                print("Deleting previous user entry")
            }
        } catch {
            print ("Failed to Delete logged user")
        }
        
        let userData: Data = try! NSKeyedArchiver.archivedData(withRootObject: _currentUser!, requiringSecureCoding: false) as Data
        
        do {
            try userData.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print("\(#function). Failed to write", error.localizedDescription)
        }
    }
    
    class func logOutCurrentUser() {
        let path: String = UserManager.pathWithObjectType(objectType: UserManager.userType)
        do {
            try FileManager.default.removeItem(atPath: path)
            if FileManager.default.fileExists(atPath: path) {
                print("\(#function). Deleting previous user entry")
            }
        } catch {
            print("\(#function). Failed to Delete user File")
        }
        _currentUser = nil
    }
    
    class func logOutUserAndClearToken() {
        UserManager.logOutCurrentUser()
        UserManager.setCurrentUser(newCurrentUser: nil)
        UserManager.setToken(token: "")
    }
    
    class func isLoggedIn() -> Bool {
        return _currentUser != nil && (_token?.count)!>0
    }
    
    class internal func setToken(token: String) {
        _token = token
        if _token != nil {
            UserDefaults.standard.set(_token, forKey: UserManagerUserToken)
        } else {
            UserDefaults.standard.removeObject(forKey: UserManagerUserToken)
        }
        UserDefaults.standard.synchronize()
    }
    
    class internal func setAnonymusToken(anonymusToken: String) {
        _anonymusToken = anonymusToken
        if _token != nil {
            UserDefaults.standard.set(_anonymusToken, forKey: UserManagerUserAnonymusToken)
        } else {
            UserDefaults.standard.removeObject(forKey: UserManagerUserAnonymusToken)
        }
        UserDefaults.standard.synchronize()
    }
    
    class internal func setUserName(userName: String) {
        _userName = userName
        if _userName != nil {
            UserDefaults.standard.set(_userName, forKey: UserManagerUserName)
        } else {
            UserDefaults.standard.removeObject(forKey: UserManagerUserName)
        }
        UserDefaults.standard.synchronize()
    }
    
    class internal func setIsUserAllowedToUseVTO(isUserAllowedToUseVTO: Bool) {
        _isUserAllowedToUseVTO = isUserAllowedToUseVTO
        if _isUserAllowedToUseVTO != nil {
            UserDefaults.standard.set(_isUserAllowedToUseVTO, forKey: UserManagerIsUserAllowedToUseVTO)
        } else {
            UserDefaults.standard.removeObject(forKey: UserManagerIsUserAllowedToUseVTO)
        }
        UserDefaults.standard.synchronize()
    }
    
    class internal func setIsPersonalFitPlusAllowed(isPersonalFitPlusAllowed: Bool) {
        _isPersonalFitPlusAllowed = isPersonalFitPlusAllowed
        if _isPersonalFitPlusAllowed != nil {
            UserDefaults.standard.set(_isPersonalFitPlusAllowed, forKey: UserManagerIsPersonalFitPlusAllowed)
        } else {
            UserDefaults.standard.removeObject(forKey: UserManagerIsPersonalFitPlusAllowed)
        }
        UserDefaults.standard.synchronize()
    }
    
    class internal func setIsCustomLightAllowed(isCustomLightAllowed: Bool) {
        _isCustomLightAllowed = isCustomLightAllowed
        if _isCustomLightAllowed != nil {
            UserDefaults.standard.set(_isCustomLightAllowed, forKey: UserManagerIsCustomLightAllowed)
        } else {
            UserDefaults.standard.removeObject(forKey: UserManagerIsCustomLightAllowed)
        }
        UserDefaults.standard.synchronize()
    }
    
    class internal func setIsUserEndCustomer(isEndCustomer: Bool) {
        _isEndCustomerUser = isEndCustomer
        if _isEndCustomerUser != nil {
            UserDefaults.standard.set(_isEndCustomerUser, forKey: UserManagerIsEndCustomerUser)
        } else {
            UserDefaults.standard.removeObject(forKey: UserManagerIsEndCustomerUser)
        }
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Utility
    
    class internal func pathWithObjectType(objectType: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let finalDatabaseURL = documentsDirectory.appending("/\(objectType).bin")
        return finalDatabaseURL
    }
}
