//
//  Repository.swift
//  blogupdater
//
//  Created by una on 2018. 4. 13..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Repository {
    let identifier :  Int
    let language : String
    let name : String
    let fullName:String
}

extension Repository: Decodable {

    static func fromJSON(_ json: AnyObject) -> Repository {
        let json = JSON(json)
        
        let identifier = json["id"].intValue
        let language = json["language"].stringValue
        let name = json["name"].stringValue
        let fullName = json["full_name"].stringValue
       
        
        return Repository(identifier: identifier, language: language, name: name, fullName: fullName)
    }
}
