//
//  ConnectionManager.swift
//  YOUMAWO
//
//  Created by Admin on 9/6/19.
//  Copyright © 2019 YOUMAWO. All rights reserved.
//

import Foundation
import Connectivity
import RxSwift

public class ConnectionManager: NSObject {
    
    static var shared: ConnectionManager {
        return ConnectionManager()
    }
    
    let disposeBag = DisposeBag()
    let connectivity = Connectivity()
    
    override init() {
        super.init()
    }
    
    func getConnection() -> Bool {
        let wlanConnection = connectivity.isConnectedViaWiFiWithoutInternet
        let mobileConnection = connectivity.isConnectedViaCellularWithoutInternet
        
        return wlanConnection || mobileConnection
    }
}
