//
//  Content.swift
//  blogupdater
//
//  Created by una on 2018. 4. 17..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Content {
    let type :String
    let name : String
    let path : String
    let htmlUrl: String
    let downloadUrl : String
    let sha:String
    
}

extension Content:Decodable{
    
    static func fromJSON(_ json: AnyObject) -> Content {
        let json = JSON(json)
        
        let type = json["type"].stringValue
        let name = json["name"].stringValue
        let path = json["path"].stringValue
        let htmlUrl = json["html_url"].stringValue
        let downloadUrl = json["download_url"].stringValue
        let sha = json["sha"].stringValue
        
        return Content(type: type, name: name, path: path, htmlUrl: htmlUrl, downloadUrl:downloadUrl,sha:sha)
    }
}
