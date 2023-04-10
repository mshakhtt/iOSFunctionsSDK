//
//  MultipartFileData.swift
//  OneOfOne
//
//  Created by vbtsukat on 22.11.2021.
//  Copyright © 2021 YOUMAWO. All rights reserved.
//

import Foundation

class MultipartFileData: NSObject {
    var fileData = Data()
    var name = ""
    var fileName = ""
    var mimeType = ""

    init(fileData: Data?, name: String?, fileName: String?, mimeType: String?) {
        super.init()

        if let fileData = fileData {
            self.fileData = fileData
        }
        self.name = name ?? ""
        self.fileName = fileName ?? ""
        self.mimeType = mimeType ?? ""
    }
}
