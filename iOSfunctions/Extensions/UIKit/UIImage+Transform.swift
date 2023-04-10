//
//  UIImage+Transform.swift
//  OneOfOne
//
//  Created by tsukat on 28.10.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import UIKit

public extension UIImage {
    
    func scaleImageBy(_ scale: CGFloat) -> UIImage {
        guard let cgImage = self.cgImage else {
            print("Error getting cgimage for scaleImageBy")
            return self
        }
        
        // Get data needed for image context creation from initial image.
        let widthScaled = CGFloat(cgImage.width) * scale
        let heightScaled = CGFloat(cgImage.height) * scale
        
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let bitmapInfo = cgImage.bitmapInfo
        
        guard let colorSpace = cgImage.colorSpace else {
            print("Error getting colorSpace for scaleImageBy")
            return self
        }
        
        // Create image context.
        guard let context = CGContext(data: nil,
                                      width: Int(widthScaled),
                                      height: Int(heightScaled),
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else {
            print("Error getting context for scaleImageBy")
            return self
        }
        context.interpolationQuality = CGInterpolationQuality.high
        
        // Draw image context in a rect of scaled size.
        let rect = CGRect(x: 0, y: 0, width: widthScaled, height: heightScaled)
        context.draw(cgImage, in: rect)
        
        // Create image of CG type from image context.
        guard let cgImageScaled = context.makeImage() else {
            print("Error getting cgImageScaled for scaleImageBy")
            return self
        }
        
        // Create image with the type of UIImage from CGImage.
        let img = UIImage(cgImage: cgImageScaled)
        return img
    }
    
    func rotateImageBy(_ degrees: CGFloat) -> UIImage? {
        
        // Get rotated size of image.
        let rotatedViewBox = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let transform = CGAffineTransform(rotationAngle: degrees * .pi / 180)
        rotatedViewBox.transform = transform
        let rotatedSize = rotatedViewBox.frame.size
        UIGraphicsBeginImageContext(rotatedSize)
        
        // Create rotated image context.
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context?.rotate(by: degrees * .pi / 180)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        guard let cgImage = cgImage else {
            print("Error getting cgImg for rotateImageBy")
            return self
        }
        
        // Draw image context in a rect.
        context?.draw(cgImage, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        // Create image with the type of UIImage from CGImage.
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
