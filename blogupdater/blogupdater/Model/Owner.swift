//
//  Owner.swift
//  blogupdater
//
//  Created by una on 2018. 4. 13..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Owner {
    let id: Int
    let name: String
    let fullName: String
}

extension Owner: Decodable {
    static func fromJSON(_ json: AnyObject) -> Owner {
        let json = JSON(json)
        
        let id = json["id"].intValue
        let name = json["name"].stringValue
        let fullName = json["full_name"].stringValue
        
        return Owner(id: id, name: name, fullName: fullName)
    }
}

