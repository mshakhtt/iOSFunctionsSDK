//
//  Common.swift
//  OneOfOne
//
//  Created by veronika on 10.02.2022.
//  Copyright © 2022 YOUMAWO. All rights reserved.
//

import UIKit

public class Common {
    class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    class func isOptician() -> Bool {
        return UserDefaults.standard.isUserLoggedIn() && isPad()
    }
    
    static var canUserCreateOrder = CanUserCreateOrder.waitForResponse
}
