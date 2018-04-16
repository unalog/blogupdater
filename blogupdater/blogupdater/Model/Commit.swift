//
//  Commit.swift
//  blogupdater
//
//  Created by una on 2018. 4. 16..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Commit {
    let message : String
    let author : String
    let date : Date
}

extension Commit :Decodable{
    
    static func fromJSON(_ json: AnyObject) -> Commit {
        let json = JSON(json)
        
        let message = json["commit"]["message"].stringValue
        let author = json["commit"]["login"].stringValue
        let date = Date(fromGitHubString: json["createAt"].stringValue)
        
        return Commit(message: message, author: author, date: date)
    }
}
