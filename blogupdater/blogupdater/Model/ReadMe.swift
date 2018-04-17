//
//  ReadMe.swift
//  blogupdater
//
//  Created by una on 2018. 4. 17..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ReadMe {
    let type : String
    let name:String
    let path:String
    let htmlUrl : String
}

extension ReadMe:Decodable
{
    
    static func fromJSON(_ json: AnyObject) -> ReadMe {
        let json = JSON(json)
        
        let type = json["type"].stringValue
        let name = json["name"].stringValue
        let path = json["path"].stringValue
        let htmlUrl = json["html_url"].stringValue
        
        return ReadMe(type: type, name: name, path: path, htmlUrl:htmlUrl)
    }
}
