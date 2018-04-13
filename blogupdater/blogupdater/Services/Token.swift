//
//  Token.swift
//  blogupdater
//
//  Created by una on 2018. 4. 12..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation

struct Token {
    
    fileprivate let userDefaults : UserDefaults
    fileprivate enum UserDefaultsKeys:String{
        case Token = "TokenKey"
    }
    var token:String?{
    
        get{
            return userDefaults.string(forKey: UserDefaultsKeys.Token.rawValue)
        }
        set{
            userDefaults.set(newValue, forKey: UserDefaultsKeys.Token.rawValue)
            userDefaults.synchronize()
        }
    }
    
    var tokenExists:Bool{
        
        if let _ = token{
            return true
        }
        else{
            return false
        }
    }
    
    init(userDefaults:UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    
    
    
}
