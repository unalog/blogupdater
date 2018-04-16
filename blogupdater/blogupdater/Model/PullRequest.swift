//
//  PullRequest.swift
//  blogupdater
//
//  Created by una on 2018. 4. 16..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PullRequest {
    let title : String
    let author : String
    let date : Date
    
}

extension PullRequest : Decodable{
    
    static func fromJSON(_ json: AnyObject) -> PullRequest {
        let json = JSON(json)
        
        let title = json["title"].stringValue
        let author = json["anuthor"].stringValue
        let date = Date(fromGitHubString: json["createdAt"].stringValue)
        
        return PullRequest.init(title: title, author: author, date: date)
    }
}
