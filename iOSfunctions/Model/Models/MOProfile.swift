//
//  MOProfile.swift
//  YOUMAWO
//
//  Created by Admin on 17.09.2020.
//  Copyright © 2020 YOUMAWO. All rights reserved.
//

import Foundation

public enum CanUserCreateOrder {
    case waitForResponse
    case canCreate
    case canNotCreate
}

public final class MOProfile: NSObject, NSCoding {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    
    private struct SerializationKeys {
        static let access_token = "access_token"
        static let expireDate = "expireDate"
        static let userName = "username"
        static let anonimusToken = "anonimusToken"
        static let isUserEndCustomer = "isUserEndCustomer"
        static let isUserAllowedToUseVTO = "isUserAllowedToUseVTO"
        static let isPersonalFitPlusAllowed = "isPersonalFitPlusAllowed"
        static let isCustomLightAllowed = "isCustomLightAllowed"
    }
    
    // MARK: - Properties
    
    var expireDate: String?
    var access_token: String?
    var userName: String?
    var anonimusToken: String?
    var isUserEndCustomer: Bool?
    var isUserAllowedToUseVTO: Bool?
    var isPersonalFitPlusAllowed: Bool?
    var isCustomLightAllowed: Bool?
    
    override init() { }
    
    convenience init(token: String, userName: String, canUSEVTO: Bool = false, anonimuSToken: String = "", isUserEndCustomer: Bool = false, isUserAllowedToUseVTO: Bool, isPersonalFitPlusAllowed: Bool, isCustomLightAllowed: Bool) {
        self.init()
        self.access_token = token
        self.userName = userName
        self.anonimusToken = anonimuSToken
        self.isUserEndCustomer = isUserEndCustomer
        self.isUserAllowedToUseVTO = isUserAllowedToUseVTO
        self.isPersonalFitPlusAllowed = isPersonalFitPlusAllowed
        self.isCustomLightAllowed = isCustomLightAllowed
    }
    
    convenience init(_ dictionary: Dictionary<String, AnyObject>) {
        self.init()
        self.access_token = dictionary[SerializationKeys.access_token] as? String
        self.userName = dictionary[SerializationKeys.userName] as? String
        self.expireDate = dictionary[SerializationKeys.expireDate] as? String
        self.anonimusToken = dictionary[SerializationKeys.anonimusToken] as? String
        self.isUserEndCustomer = dictionary[SerializationKeys.isUserEndCustomer] as? Bool
        self.isUserAllowedToUseVTO = dictionary[SerializationKeys.isUserAllowedToUseVTO] as? Bool
        self.isPersonalFitPlusAllowed = dictionary[SerializationKeys.isPersonalFitPlusAllowed] as? Bool
        self.isCustomLightAllowed = dictionary[SerializationKeys.isCustomLightAllowed] as? Bool
    }
    
    // MARK: NSCoding Protocol
    
    required public init(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObject(forKey: SerializationKeys.access_token) as? String
        self.expireDate = aDecoder.decodeObject(forKey: SerializationKeys.expireDate) as? String
        self.userName = aDecoder.decodeObject(forKey: SerializationKeys.userName) as? String
        self.anonimusToken = aDecoder.decodeObject(forKey: SerializationKeys.anonimusToken) as? String
        self.isUserEndCustomer = aDecoder.decodeObject(forKey: SerializationKeys.isUserEndCustomer) as? Bool
        self.isUserAllowedToUseVTO = aDecoder.decodeObject(forKey: SerializationKeys.isUserAllowedToUseVTO) as? Bool
        self.isPersonalFitPlusAllowed = aDecoder.decodeObject(forKey: SerializationKeys.isPersonalFitPlusAllowed) as? Bool
        self.isCustomLightAllowed = aDecoder.decodeObject(forKey: SerializationKeys.isCustomLightAllowed) as? Bool
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token,forKey: SerializationKeys.access_token)
        aCoder.encode(expireDate,forKey: SerializationKeys.expireDate)
        aCoder.encode(userName, forKey: SerializationKeys.userName)
        aCoder.encode(anonimusToken, forKey: SerializationKeys.anonimusToken)
        aCoder.encode(isUserEndCustomer, forKey: SerializationKeys.isUserEndCustomer)
        aCoder.encode(isUserAllowedToUseVTO, forKey: SerializationKeys.isUserAllowedToUseVTO)
        aCoder.encode(isPersonalFitPlusAllowed, forKey: SerializationKeys.isPersonalFitPlusAllowed)
        aCoder.encode(isCustomLightAllowed, forKey: SerializationKeys.isCustomLightAllowed)
    }
}
