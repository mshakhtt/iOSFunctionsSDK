//
//  DocumentDirectoryManager.swift
//  iOSfunctions
//
//  Created by Shandor Baloh on 06.03.2023.
//

import Foundation

public class DocumentDirectoryManager {
 
    class func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return documentDirectory[0]
    }
    
    class func getDocumentsURL() -> URL {
        let urlStr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let url = URL(string: urlStr!)
        return url!
    }
    
    class func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            return pathURL.absoluteString
        }
        return nil
    }
    
    class func save(text: String, toDirectory directory: String, withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory, withPathComponent: fileName) else {
            return
        }
        do {
            try text.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("\(#function) Error: ", error.localizedDescription)
            return
        }
        print("\(#function) Save successful \(fileName)")
    }
}
