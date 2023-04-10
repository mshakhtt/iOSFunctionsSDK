//
//  PortalUrl.swift
//  OneOfOne
//
//  Created by Admin on 24.06.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

public struct PortalURL {
    
    // MARK: - Properties
    
    static var shared = PortalURL()
    
    var catalogURL: String?
    var termsURL: String?
    var policyURL: String?
    var portalURL: String?
    var parameterInfoURL: String?
    var newOrderURL: String?
    var orderOverviewURL: String?
    var scanOverviewURL: String?
    var findAStoreURL: String?
    var aboutTheProductURL: String?
    var ourStoryURL: String?
    var inspirationURL: String?
    var lookBookURL: String?
    var newsURL: String?
    var resetPasswordURL: String?
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Methods
    
    mutating func setUrlForCatalogItem(url: String) {
        self.catalogURL = url
    }
    
    func getUrlForCatalogItem() -> String? {
        return self.catalogURL
    }
    
    mutating func setUrlForFindAStoreItem(url: String) {
        self.findAStoreURL = url
    }
    
    func getUrlForFindAStoreItem() -> String? {
        return self.findAStoreURL
    }
    
    mutating func setUrlForAboutTheProductyItem(url: String) {
        self.aboutTheProductURL = url
    }
    
    func getUrlForAboutTheProductItem() -> String? {
        return self.aboutTheProductURL
    }
    
    mutating func setUrlForOurStoryItem(url: String) {
        self.ourStoryURL = url
    }
    
    func getUrlForOurStoryItem() -> String? {
        return self.ourStoryURL
    }
    
    mutating func setUrlForLookBookItem(url: String) {
        self.lookBookURL = url
    }
    
    func getUrlForLookBookItem() -> String? {
        return self.lookBookURL
    }
    
    mutating func setUrlForNewsItem(url: String) {
        self.newsURL = url
    }
    
    func getUrlForNewsItem() -> String? {
        return self.newsURL
    }
    
    mutating func setUrlForTermsItem(url: String) {
        self.termsURL = url
    }
    
    func getUrlForTermsItem() -> String? {
        return self.termsURL
    }
    
    mutating func setUrlForPortalItem(url: String) {
        self.portalURL = url
    }
    
    func getUrlForPortalItem() -> String? {
        return self.portalURL
    }
    
    mutating func setUrlForOrderOverviewItem(url: String) {
        self.orderOverviewURL = url
    }
    
    func getUrlForOrderOverviewItem() -> String? {
        return self.orderOverviewURL
    }
    
    mutating func setUrlForScanOverviewItem(url: String) {
        self.scanOverviewURL = url
    }
    
    func getUrlForScanOverviewItem() -> String? {
        return self.scanOverviewURL
    }
    
    mutating func setUrlForPolicyItem(url: String) {
        self.policyURL = url
    }
    
    func getUrlForPolicyItem() -> String? {
        return self.policyURL
    }
    
    mutating func setUrlForNewOrderItem(url: String) {
        self.newOrderURL = url
    }
    
    func getUrlForNewOrderItem() -> String? {
        return self.newOrderURL
    }
}
