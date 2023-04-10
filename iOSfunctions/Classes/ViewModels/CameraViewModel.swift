//
//  CameraViewModel.swift
//  OneOfOne
//
//  Created by vbtsukat on 10.11.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation
import UIKit

public class CameraViewModel {
    
    // MARK: - Properties
    
    var maxSideOfImage: Float = 2000
    var initialInfoDisplayed = false
    var selectedImage: UIImage?
    var images: [UIImage]?
    var imageViews: [UIImageView]?
    
    // MARK: - Init
    
    init() {
        self.imageViews = [UIImageView]()
        self.images = [UIImage]()
    }
    
    init(imageViews: [UIImageView]?) {
        self.imageViews = imageViews
        self.images = [AnyHashable](repeating: 0, count: imageViews?.count ?? 0) as? [UIImage]
    }
    
    // MARK: - Methods
    
    func add(_ image: UIImage?) {
        let condition = (image?.size.width ?? 0.0) > (image?.size.height ?? 0.0)
        let resizedImage = condition ? UIImage.resize(toWidth: image, andWidth: CGFloat(maxSideOfImage)) : UIImage.resize(toHeight: image, andHeight: CGFloat(maxSideOfImage))
        
        if let resizedImage = resizedImage {
            images?.append(resizedImage)
        }
    }
    
    func addImage(atIndex image: UIImage?, at index: Int) {
        let condition = (image?.size.width ?? 0.0) > (image?.size.height ?? 0.0)
        let resizedImage = condition ? UIImage.resize(toWidth: image, andWidth: CGFloat(maxSideOfImage)) : UIImage.resize(toHeight: image, andHeight: CGFloat(maxSideOfImage))
        
        if let resizedImage = resizedImage {
            images?.insert(resizedImage, at: index)
        }
    }
    
    func remove(_ image: UIImage?) {
        if let image = image {
            if images?.contains(image) ?? false {
                images?.removeAll { $0 === image }
            }
        }
    }
}
