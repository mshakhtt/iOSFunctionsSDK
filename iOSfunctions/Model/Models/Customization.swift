//
//  Customization.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 23.03.2023.
//

import Foundation

public struct Customization: Codable {
    var bridgeLength: Int
    var pdLeft: Int
    var pdRight: Int
    var size: Int
    var templeLengthLeft: Int
    var templeLengthRight: Int
    var basisCurve: Int
    var inclination: Int
    var comments: String
    var inscription: String
    
    init() {
        self.bridgeLength = 0
        self.pdLeft = 33
        self.pdRight = 33
        self.size = 0
        self.templeLengthLeft = 0
        self.templeLengthRight = 0
        self.basisCurve = 4
        self.inclination = 0
        self.comments = ""
        self.inscription = ""
    }
    
    init(bridgeLength: Int,
         pdLeft: Int,
         pdRight: Int,
         size: Int,
         templeLengthLeft: Int,
         templeLengthRight: Int,
         basisCurve: Int,
         inclination: Int,
         comments: String,
         inscription: String) {
        self.bridgeLength = bridgeLength
        self.pdLeft = pdLeft
        self.pdRight = pdRight
        self.size = size
        self.templeLengthLeft = templeLengthLeft
        self.templeLengthRight = templeLengthRight
        self.basisCurve = basisCurve
        self.inclination = inclination
        self.comments = comments
        self.inscription = inscription
    }
}
