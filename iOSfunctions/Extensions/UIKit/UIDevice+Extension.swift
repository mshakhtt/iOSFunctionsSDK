//
//  UIDevice+Extension.swift
//  OneOfOne
//
//  Created by tsukat on 28.10.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import UIKit

extension UIDevice {
    var deviceModel: String? {
        var systemInfo = utsname()
        uname(&systemInfo)
        let str = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        return str
    }
    
    var iosVersion: String {
        return "\(systemName)\(systemVersion)"
    }
}
