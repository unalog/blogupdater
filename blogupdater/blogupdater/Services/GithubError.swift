//
//  GithubError.swift
//  blogupdater
//
//  Created by una on 2018. 4. 13..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation

enum GithubError:Error{
    
    case notAuthenticated
    case rateLimitExceeded
    case wrongJSONParsing
    case generic
}
