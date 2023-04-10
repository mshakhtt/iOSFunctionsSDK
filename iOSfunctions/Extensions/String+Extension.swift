//
//  NSAttributedString+Extension.swift
//  YOUMAWO
//
//  Created by Andreas Wörner on 05.10.18.
//  Copyright © 2018 YOUMAWO. All rights reserved.
//

import UIKit

public extension String {
    
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    var htmlAttributedString: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    var containsInValidCharacter: Bool {
        guard self != "" else { return true }
        
        let allowedSymbols = "@. -+()/:"
        var alphanumerics = NSCharacterSet.alphanumerics
        
        alphanumerics.insert(charactersIn: allowedSymbols)
        
        let filtered = self
            .components(separatedBy: alphanumerics)
            .joined(separator: "")
        return filtered != self
    }
    
    func htmlAttributedString(font: UIFont?, color: UIColor?) -> NSAttributedString? {
        guard let font = font else {
            return htmlAttributedString
        }
        
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px;}</style>\(self)"
        
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            attributedString.enumerateAttribute(.font, in: NSRange(0..<attributedString.length)) { value, range, stop in
                if let font = value as? UIFont {
                    if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                        attributedString.addAttribute(.foregroundColor, value: color, range: range)
                    }
                }
            }
            return attributedString
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func removeAllSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    func imageWith(name: String?, textAlignment: NSTextAlignment = .center, textClolor: UIColor, backgroundColor: UIColor, alpha: CGFloat = 0.99) -> UIImage? {
        if name == "0" {
            return nil
        }
        
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let LView = UIView(frame: frame)
        LView.layer.cornerRadius = 15
        LView.layer.masksToBounds = true
        
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = textAlignment
        nameLabel.textColor = textClolor
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.Spectral(.regular, size: 30)
        nameLabel.text = name
        nameLabel.backgroundColor = backgroundColor.withAlphaComponent(alpha)
        
        LView.addSubview(nameLabel)
        LView.contentMode = .center
        
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            LView.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    func replaceUmlautSymbols() -> String {
        var replacedString = self.replacingOccurrences(of: "ä", with: "ae")
        replacedString = replacedString.replacingOccurrences(of: "ö", with: "oe")
        replacedString = replacedString.replacingOccurrences(of: "ü", with: "ue")
        replacedString = replacedString.replacingOccurrences(of: "Ä", with: "Ae")
        replacedString = replacedString.replacingOccurrences(of: "Ö", with: "Oe")
        replacedString = replacedString.replacingOccurrences(of: "Ü", with: "Ue")
        replacedString = replacedString.replacingOccurrences(of: "ß", with: "ss")
        return replacedString
    }
}

extension RangeReplaceableCollection where Self: StringProtocol {
    var digits: Self {
        return filter({ $0.isNumber })
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
