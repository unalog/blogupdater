//
//  GitHubAPI.swift
//  blogupdater
//
//  Created by una on 2018. 4. 12..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import Moya
import RxSwift


public enum GitHub{
    case token(username:String, password:String)
    case userProfile(username:String)
    case repos(username:String)
    case repo(fullName:String)
    case issues(repositoryFullName:String)
}

private extension String{
    var URLEscapedString:String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

let GitHubProvider = MoyaProvider<GitHub>(endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true)])

extension GitHub: TargetType{
    
    public var baseURL : URL{
        return URL(string: "https://api.github.com")!
    }
    
    public var path:String{
        switch self {
        case .token(_, _):
            return "/authorizations"
        case .issues(let repositoryFullName):
            return "/repos/\(repositoryFullName)/issues"
        case .userProfile(let name):
            return "/users\(name.URLEscapedString)"
        case .repos(let name):
            return "/users/\(name.URLEscapedString)/repos"
        case .repo(let name):
            return "/repos/\(name)"
        }
    }
    
    public var method: Moya.Method{
        switch self {
        case .token(_, _):
            return .post
        default:
            return .get
        }
    }
    public var headers: [String : String]? {
        switch self {
        case .token(let userString, let passwordString):
            let credentialData = "\(userString):\(passwordString)".data(using: String.Encoding.utf8)!
            let base64Credentials = credentialData.base64EncodedString(options: [])
            return ["Authorization": "Basic \(base64Credentials)"]
        default:
            let appToken = Token()
            guard let token = appToken.token else{
               return ["Authorization": "token)"]
            }
            return ["Authorization": "token \(token)"]
        }
    }
   
    public var parameterEncoding:ParameterEncoding{
        return URLEncoding.default
    }
    
    public var sampleData:Data{
        switch self {
        case .token(_, _):
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .repos(_):
            return "}".data(using: .utf8)!
        case .userProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: .utf8)!
        case .repo(_):
            return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".data(using: .utf8)!
        case .issues(_):
            return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".data(using: .utf8)!
            
        }
    }
    
    public var task:Task{
        switch self {
        case .token(_, _):
            let params = ["scopes":["public_repo", "user"], "note": "BlogUploader iOS app (\(Date()))"] as [String : Any]
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
}

var endpointClosure = {( target:GitHub) -> Endpoint in
    
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let endpoint : Endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200,target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    
    return endpoint
}


