//
//  Localization.swift
//  OneOfOne
//
//  Created by tsukat on 05.11.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

public class Localization {
    
    // MARK: - Properties

    static let shared = Localization()

    let english = Languages.en.rawValue
    let german = Languages.de.rawValue
    let french = Languages.fr.rawValue
    let spanish = Languages.es.rawValue
    
    let en = Languages.en.abbreviation()
    let de = Languages.de.abbreviation()
    let fr = Languages.fr.abbreviation()
    let es = Languages.es.abbreviation()
    
    var currentLanguage = Languages.en.rawValue
    
    // MARK: - Methods
    
    func getCurrentLanguageName() -> String {
        return currentLanguage
    }
    
    func getLocalizedString(forKey key: String?) -> String? {
        let preferredLanguage = Locale.preferredLanguages[0] as String
        let deviceLanguage = preferredLanguage.components(separatedBy: "-").first
        
        var path: String?
        
        switch (deviceLanguage) {
        case en:
            currentLanguage = english
            path = Bundle.main.path(forResource: en, ofType: "lproj")
        case de:
            currentLanguage = german
            path = Bundle.main.path(forResource: de, ofType: "lproj")
        case fr:
            currentLanguage = french
            path = Bundle.main.path(forResource: fr, ofType: "lproj")
        case es:
            currentLanguage = spanish
            path = Bundle.main.path(forResource: es, ofType: "lproj")
        default:
            currentLanguage = english
            path = Bundle.main.path(forResource: en, ofType: "lproj")
        }

        let languageBundle = Bundle(path: path ?? "")
        let str = languageBundle?.localizedString(forKey: key ?? "", value: "", table: "Localizable")
        return str
    }
}
