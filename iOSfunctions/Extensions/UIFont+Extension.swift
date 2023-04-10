//
//  UIFont+Extension.swift
//  YOUMAWO
//
//  Created by Andreas Wörner on 05.10.18.
//  Copyright © 2018 YOUMAWO. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    enum SFProTextType: String {
        case black = "-Black"
        case blackItalic = "-BlackItalic"
        case bold = "-Bold"
        case boldItalic = "-BoldItalic"
        case heavy = "-Heavy"
        case heavyItalic = "-HeavyItalic"
        case ligh = "-Ligh"
        case lighItalic = "-LighItalic"
        case medium = "-Medium"
        case mediumItalic = "-MediumItalic"
        case regular = "-Regular"
        case regularItalic = "-RegularItalic"
        case semibold = "-Semibold"
        case semiboldItalic = "-SemiboldItalic"
        case thin = "-Thin"
        case thinItalic = "-ThinItalic"
        case ultralight = "-Ultralight"
        case ultralightItalic = "-UltralightItalic"
    }
    
    enum SpectralType: String {
        case bold = "-Bold"
        case boldItalic = "-BoldItalic"
        case extraBolld = "-ExtraBold"
        case extraBoldItalic = "-ExtraBoldItalic"
        case extraLigh = "-ExtraLigh"
        case extrLighItalic = "-ExtraLighItalic"
        case ligh = "-Ligh"
        case lighItalic = "-LighItalic"
        case medium = "-Medium"
        case mediumItalic = "-MediumItalic"
        case regular = "-Regular"
        case semibold = "-Semibold"
        case semiboldItalic = "-SemiboldItalic"
        case italic = "-Italic"
    }
    
    static func SFProText(_ type: SFProTextType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "SFProText\(type.rawValue)", size: size)!
    }
    
    static func Spectral(_ type: SpectralType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "Spectral\(type.rawValue)", size: size)!
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}

