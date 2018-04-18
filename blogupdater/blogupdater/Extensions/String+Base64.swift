//
//  String+addition.swift
//  blogupdater
//
//  Created by una on 2018. 4. 18..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation

extension String{
    
    func fromBase64()->String?  {
        
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String? {
        
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }

    static func toBase64File(url:URL!) -> String? {
        
        do{
            let fileData = try Data.init(contentsOf: url)
            let fileStream:String = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            
            return fileStream
        }catch{
            return nil
        }
        
    }
}
