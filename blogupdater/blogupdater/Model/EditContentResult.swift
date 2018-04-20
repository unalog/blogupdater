//
//  EditFileResult.swift
//  blogupdater
//
//  Created by una on 2018. 4. 19..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import SwiftyJSON

struct EditContentResult {
    let content:Content
}

extension EditContentResult:Decodable{
    
    static func fromJSON(_ json: AnyObject) -> EditContentResult {
        let json = JSON(json)
        
        let content = Content.fromJSON(json["content"].object as AnyObject)
        
        return EditContentResult(content: content)
    }
}
