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
    let content:String
    let sha:String
    let url : String
    let git_url:String
    let html_url : String
    let download_url:String
}

extension ReadMe:Decodable
{
    
    static func fromJSON(_ json: AnyObject) -> ReadMe {
        let json = JSON(json)
        
        let type = json["type"].stringValue
        let name = json["name"].stringValue
        let path = json["path"].stringValue
        let content = json["content"].stringValue
        let sha = json["sha"].stringValue
        let url = json["url"].stringValue
        let git_url = json["git_url"].stringValue
        let html_url = json["html_url"].stringValue
        let download_url = json["download_url"].stringValue
        
        return ReadMe(type: type, name: name, path: path, content: content, sha: sha, url: url, git_url: git_url, html_url: html_url, download_url: download_url)
    }
}
