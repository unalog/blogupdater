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
        
        }
    }
    
    public var method: Moya.Method{
        switch self {
        case .token(_, _):
            return .post
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

private extension String{
    var URLEscapedString:String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
