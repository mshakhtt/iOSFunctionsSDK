//
//  VTOViewModel.swift
//  OneOfOne
//
//  Created by Admin on 17.03.2022.
//  Copyright © 2022 YOUMAWO. All rights reserved.
//

import Foundation

public class VTOViewModel {
    
    // MARK: - Properties
    
    var frameColorName: String
    var frameColorIndex: Int
    var frameColorId: Int
    var frameColorHex: String
    var hingeColorName: String
    var hingeColorIndex: Int
    var hingeColorHex: String
    var hingeColorFeatureId: Int
    var templeColorName: String
    var templeColorIndex: Int
    var templeColorHex: String
    var templeColorFeatureId: Int
    var frameSize: Int
    var bridgeSize: Int
    var pantoscopicAngle: Int
    var baseCurve: Int
    var templeLength: Int
    var featureIds: [String]
    
    // MARK: - Init
    
    init() {
        self.frameColorName = "01 - black"
        self.frameColorIndex = 0
        self.frameColorId = 1
        self.frameColorHex = "#171717"
        self.hingeColorName = "Silver"
        self.hingeColorIndex = 0
        self.hingeColorFeatureId = -1
        self.hingeColorHex = "#C0C0C0"
        self.templeColorName = ""
        self.templeColorIndex = 0
        self.templeColorFeatureId = -1
        self.templeColorHex = ""
        self.frameSize = LocalConstants.FrameDefaultSettings.frameSize
        self.bridgeSize = LocalConstants.FrameDefaultSettings.bridgeSize
        self.pantoscopicAngle = LocalConstants.FrameDefaultSettings.pantoscopicAngle
        self.baseCurve = LocalConstants.FrameDefaultSettings.baseCurve
        self.templeLength = LocalConstants.FrameDefaultSettings.templeLenght
        self.featureIds = [""]
    }
    
    init(frameColorName: String, frameColorIndex: Int, frameColorId: Int, frameColorHex: String, hingeColorName: String, hingeColorIndex: Int, hingeColorHex: String, hingeColorFeatureId: Int, templeColorName: String, templeColorIndex: Int, templeColorHex: String, templeColorFeatureId: Int, frameSize: Int, bridgeSize: Int, pantoscopicAngle: Int, baseCurve: Int, templeLength: Int, featureIds: [String]) {
        self.frameColorName = frameColorName
        self.frameColorIndex = frameColorIndex
        self.frameColorId = frameColorId
        self.frameColorHex = frameColorHex
        self.hingeColorName = hingeColorName
        self.hingeColorIndex = hingeColorIndex
        self.hingeColorHex = hingeColorHex
        self.hingeColorFeatureId = hingeColorFeatureId
        self.templeColorName = templeColorName
        self.templeColorIndex = templeColorIndex
        self.templeColorHex = templeColorHex
        self.templeColorFeatureId = templeColorFeatureId
        self.frameSize = frameSize
        self.bridgeSize = bridgeSize
        self.pantoscopicAngle = pantoscopicAngle
        self.baseCurve = baseCurve
        self.templeLength = templeLength
        self.featureIds = featureIds
    }
}
