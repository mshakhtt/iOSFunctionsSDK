//
//  Bundle+Extension.swift
//  OneOfOne
//
//  Created by Admin on 02.11.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

public extension Bundle {
    
    class var applicationVersionNumber: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "Version Number Not Available"
    }
    
    class var applicationBuildNumber: String {
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return build
        }
        return "Build Number Not Available"
    }
}
