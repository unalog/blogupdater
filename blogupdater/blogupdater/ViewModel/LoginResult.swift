//
//  LoginResult.swift
//  blogupdater
//
//  Created by una on 2018. 4. 12..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation

enum LoginResult{
    
    case ok
    case field(message:String)
}

extension LoginResult: Equatable{}

func ==(lhs : LoginResult, rhs:LoginResult) -> Bool {
    
    switch (lhs,rhs) {
    case (.ok , .ok):
        return true
    case (.field(let x), .field(let y))
        where x == y:
        return true
    default:
        return false
    }
}
