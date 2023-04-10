//
//  RestClientProtocol.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 05.03.2023.
//

import Foundation

protocol RestClientProtocol {
    typealias Handler = (Result<[Collection], Error>) -> Void
    typealias VTOHandler = (Result<String, Error>) -> Void
    typealias CountryHandler = (Result<[Country], Error>) -> Void

    func getCanUseVTO(_ completionHandler: @escaping VTOHandler)
    func getCountries(_ completionHandler: @escaping CountryHandler)
}
