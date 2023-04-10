//
//  LocalSettings.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 06.03.2023.
//

import Foundation

public struct LocalSettings: Equatable, Hashable, Codable {
    public var frameColorIndex = 0
    public var frameHingeColorIndex = 0
    public var frameTempleColorIndex = 0
    public var frameSizeValue = LocalConstants.FrameDefaultSettings.frameSize
    public var frameBridgeSizeValue = LocalConstants.FrameDefaultSettings.bridgeSize
    public var frameColorHex = ""
    public var frameHingeColorHex = ""
    public var frameTempleLenght = LocalConstants.FrameDefaultSettings.templeLenght
    public var frameBaseCurve = LocalConstants.FrameDefaultSettings.baseCurve
    public var framePantoscopicAngle = LocalConstants.FrameDefaultSettings.pantoscopicAngle
    
    public init() {
        self.frameColorIndex = 0
        self.frameHingeColorIndex = 0
        self.frameTempleColorIndex = 0
        self.frameSizeValue = LocalConstants.FrameDefaultSettings.frameSize
        self.frameBridgeSizeValue = LocalConstants.FrameDefaultSettings.bridgeSize
        self.frameColorHex = "#171717"
        self.frameHingeColorHex = "#C0C0C0"
        self.frameBaseCurve = LocalConstants.FrameDefaultSettings.baseCurve
        self.frameTempleLenght = LocalConstants.FrameDefaultSettings.templeLenght
        self.framePantoscopicAngle = LocalConstants.FrameDefaultSettings.pantoscopicAngle
    }
    
    public init(frameColorIndex: Int, frameHingeColorIndex: Int, frameTempleColorIndex: Int, frameSizeValue: Int, frameBridgeSizeValue: Int, frameColorHex: String, frameHingeColorHex: String, frameTempleLenght: Int, framePantoscopicAngle: Int, frameBaseCurve: Int) {
        self.frameColorIndex = frameColorIndex
        self.frameHingeColorIndex = frameHingeColorIndex
        self.frameTempleColorIndex = frameTempleColorIndex
        self.frameSizeValue = frameSizeValue
        self.frameBridgeSizeValue = frameBridgeSizeValue
        self.frameColorHex = frameColorHex
        self.frameHingeColorHex = frameHingeColorHex
        self.frameTempleLenght = frameTempleLenght
        self.framePantoscopicAngle = framePantoscopicAngle
        self.frameBaseCurve = frameBaseCurve
    }
}
