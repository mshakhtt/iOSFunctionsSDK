//
//  UIImage+Extension.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 01.03.2023.
//

import UIKit

public extension UIImage {
    static func resize(toWidth image: UIImage?, andWidth width: CGFloat, compressionQuality: Float = 0.75) -> UIImage? {
        let actualHeight = Float(image?.size.height ?? 0.0)
        let actualWidth = Float(image?.size.width ?? 0.0)
        let maxWidth = Float(width)
        let maxHeight = (maxWidth * actualHeight) / actualWidth
        
        if actualWidth < maxWidth {
            return image
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(maxWidth), height: CGFloat(maxHeight))
        UIGraphicsBeginImageContext(rect.size)
        image?.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        
        print(String(format: "Size of Image(bytes):%ld", UInt(imageData?.count ?? 0)))
        
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    static func resize(toHeight image: UIImage?, andHeight height: CGFloat, compressionQuality: Float = 0.75) -> UIImage? {
        let actualHeight = Float(image?.size.height ?? 0.0)
        let actualWidth = Float(image?.size.width ?? 0.0)
        let maxHeight = Float(height)
        let maxWidth = (maxHeight * actualWidth) / actualHeight
        
        if actualHeight < maxHeight {
            return image
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(maxWidth), height: CGFloat(maxHeight))
        UIGraphicsBeginImageContext(rect.size)
        image?.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        
        print("Size of Image(bytes): \(imageData?.count ?? 0)")
        
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}
