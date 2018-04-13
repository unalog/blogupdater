//
//  Decodable.swift
//  blogupdater
//
//  Created by una on 2018. 4. 13..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation

protocol Decodable {
    static func fromJSON(_ json: AnyObject) -> Self
}

extension Decodable{
    
    static func fromJSONArray(_ json:[AnyObject]) -> [Self] {
        return json.map{ Self.fromJSON($0) }
    }
}
