//
//  ProgressBar+Extension.swift
//  YOUMAWO
//
//  Created by Admin on 02.03.2020.
//  Copyright © 2020 YOUMAWO. All rights reserved.
//

import UIKit

extension UIProgressView {

    @IBInspectable public var barHeight: CGFloat {
        get {
            return transform.d * 2.0
        }
        set {
            // 2.0 Refers to the default height of 2
            let heightScale = newValue / 2.0
            let c = center
            transform = CGAffineTransform(scaleX: 1.0, y: heightScale)
            center = c
        }
    }
}
