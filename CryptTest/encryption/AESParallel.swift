//
//  AESParallel.swift
//  CryptTest
//
//  Created by Wes van der Vleuten on 14/03/2018.
//  Copyright © 2018 Wes van der Vleuten. All rights reserved.
//

import Foundation
import UIKit

final public class AESParallel {
    
    init() {
    }
    
    
    public func decrypt(file: URL, key: Data, callback: @escaping ((URL) throws -> Void)) throws -> Void {
        print("Initializing")
        let fileURL = file
        let filedataopt = NSData(contentsOf: fileURL)
        if (filedataopt == nil) {
            throw NSError(domain: "filedata is nil", code: 0, userInfo: nil)
        }
        let filename = file.lastPathComponent
        let filedata = filedataopt!
        var filearr = filename.split(separator: ".")
        let fileextension = filearr.popLast()!
        let filetitle = filearr.joined(separator: ".")
        
        var iv: Data
        var encdata: Data
        
        if (fileextension == "wdcs") {
            let length = filedata.length
            let version = filedata.subdata(with: NSMakeRange(0, 1))[0]
            if (version == 1) {
                iv = filedata.subdata(with: NSMakeRange(34, 50))
                encdata = filedata.subdata(with: NSMakeRange(50, length-50))
            } else {
                throw NSError(domain: "Unkown wdcs version", code: 0, userInfo: nil)
            }
        } else if(fileextension == "enc") {
            let length = filedata.length
            iv = filedata.subdata(with: NSMakeRange(0, 16))
            encdata = filedata.subdata(with: NSMakeRange(16, length-16))
        } else {
            throw NSError(domain: "unkown encryption format", code: 0, userInfo: nil)
        }
        print("Transforming")
        let ivData = [UInt8](iv)
        let data = [UInt8](encdata)
        let keyData = [UInt8](key)
        
        print("Decrypting")
        
        try AESCipher(key: keyData, iv: ivData).decrypt(bytes: data, callback: {(dec: [UInt8]) throws -> Void in
            let dec = Data(bytes: dec)
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentDirectoryPath:String = path[0]
            let fileManager = FileManager()
            let rpath = documentDirectoryPath.appending("/ROOT")
            var destinationURLForFile = URL(fileURLWithPath: rpath)
            try fileManager.createDirectory(at: destinationURLForFile, withIntermediateDirectories: true, attributes: nil)
            destinationURLForFile.appendPathComponent(filetitle)
            print("Writing")
            try dec.write(to: destinationURLForFile, options: .completeFileProtection)
            print("Result:", destinationURLForFile)
            try? callback(destinationURLForFile);
        })
        
        
    }
}
