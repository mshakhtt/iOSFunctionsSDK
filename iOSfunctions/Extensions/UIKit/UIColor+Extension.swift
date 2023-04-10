//
//  UIColor+Youmawo.swift
//  OneOfOne
//
//  Created by vbtsukat on 27.10.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
     convenience init(fromHex hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    // YouMawo basic colors.
    
     class var ymBlue: UIColor {
        return UIColor(fromHex: "#49ade9")
    }
    
    // New.
     class var ymLightBlue: UIColor {
        return UIColor(fromHex: "#91C6FF")
    }
    
    // For textfield borders.
     class var ymGray: UIColor {
        return UIColor(fromHex: "#b4b4b4")
    }
    
    // For button background and texts.
     class var ymDarkGray: UIColor {
        return UIColor(fromHex: "#333333")
    }

    // For button titles.
     class var ymLightGray: UIColor {
        return UIColor(fromHex: "#f5f5f5")
    }

     class var ymLightGray2: UIColor {
        return UIColor(fromHex: "#F1F1F1")
    }
    
    // OneOfOne specific colors.
    
     class var mfDarkBlue: UIColor {
        return UIColor(fromHex: "#4C5F7A")
    }
    
     class var mfLightGray: UIColor {
        return UIColor(fromHex: "#B4B4B4")
    }
    
     class var mfBorder: UIColor {
        return UIColor(fromHex: "#707070")
    }

     class var mfTextField: UIColor {
        return UIColor(fromHex: "#231F20")
    }

     class var mfTextFieldDark: UIColor {
        return UIColor(fromHex: "#707070")
    }
    
     class var mfTitle: UIColor {
        return UIColor(fromHex: "#1A1818")
    }

     class var mfSubtitle: UIColor {
        return UIColor(fromHex: "#1A1818")
    }
    
    // 1Of1
    
     class var brandColor: UIColor {
        return UIColor(fromHex: "#03ff12")
    }
    
     class var gray1: UIColor {
        return UIColor(fromHex: "#f5f3ed")
    }
    
     class var gray2: UIColor {
        return UIColor(fromHex: "#e7e5df")
    }
    
     class var gray3: UIColor {
        return UIColor(fromHex: "#cfcdc8")
    }
    
     class var gray4: UIColor {
        return UIColor(fromHex: "#b5b4b0")
    }
    
     class var gray5: UIColor {
        return UIColor(fromHex: "#9c9a97")
    }
    
     class var gray6: UIColor {
        return UIColor(fromHex: "#82817e")
    }
    
     class var gray7: UIColor {
        return UIColor(fromHex: "#696865")
    }
    
     class var gray8: UIColor {
        return UIColor(fromHex: "#4f4e4d")
    }
    
     class var gray9: UIColor {
        return UIColor(fromHex: "#363534")
    }
    
     class var gray10: UIColor {
        return UIColor(fromHex: "#1c1c1b")
    }
    
     class var dark: UIColor {
        return UIColor(fromHex: "#17181c")
    }
     class var productDetailImageSlider: UIColor {
        return UIColor(fromHex: "#b5adad")
    }
    
     class var productDetailImageView: UIColor {
        return UIColor(fromHex: "#f7f5ef")
    }
    
     class var functionalYellow: UIColor {
        return UIColor(fromHex: "#ffee03")
    }
    
     class var functionalRed: UIColor {
        return UIColor(fromHex: "#ff5703")
    }
    
     class var frameColor: UIColor {
        return UIColor(fromHex: "#171717")
    }
    
     class var hingeColor: UIColor {
        return UIColor(fromHex: "#C0C0C0")
    }
}
