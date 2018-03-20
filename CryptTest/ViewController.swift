//
//  ViewController.swift
//  CryptTest
//
//  Created by Wes van der Vleuten on 12/03/2018.
//  Copyright © 2018 Wes van der Vleuten. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello world");
        let startTime = CFAbsoluteTimeGetCurrent()
        let key = "7w=Cm0E]>(8;Cb)2O7@30-248Ly!Y(Yd"
        let filename = "test.zip.enc"
        
        let path = Bundle.main.resourcePath!
        var file = URL(fileURLWithPath: path)
        file.appendPathComponent(filename)
        
        let keyData = key.data(using: String.Encoding.utf8)!
        DispatchQueue.global(qos: .background).async {
            do {
                try AESParallel().decrypt(file: file, key: keyData, callback: { (resultUrl: URL) throws -> Void in
                    DispatchQueue.main.async {
                        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                        print("This is run on the main queue, after the previous code in outer block")
                        print("Time elapsed: \(timeElapsed) s.")
                    }
                })
            } catch {
                print("caught error", error)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

