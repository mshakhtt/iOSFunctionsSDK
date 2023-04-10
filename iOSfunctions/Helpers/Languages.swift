//
//  Languages.swift
//  OneOfOne
//
//  Created by vbtsukat on 09.11.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

public enum Languages: String {
    case en = "English"
    case de = "Deutsch"
    case fr = "French"
    case es = "Spanish"
    
    func abbreviation() -> String {
        switch self {
        case .en: return "en"
        case .de: return "de"
        case .fr: return "fr"
        case .es: return "es"
        }
    }
    
    func vto() -> String {
        switch self {
        case .en: return "englishVTO"
        case .de: return "deutschVTO"
        case .fr: return "frenchVTO"
        case .es: return "spanishVTO"
        }
    }
}
