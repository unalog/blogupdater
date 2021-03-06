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
    case repoSearch(query: String)
    case trendingReposSinceLastWeek
    case repo(owner: String, repoName: String)
    case repoReadMe(owner: String, repoName: String)
    case pulls(owner: String, repo: String)
    case issues(owner: String, repo: String)
    case commits(owner: String, repo: String)
    case myRepos
    case readMe(owner:String, repo:String)
    case contents(owner:String, repo:String, path:String)
    case createFile(owner:String, repo:String, path:String, content:String, filename:String)
    case updateFile(owner:String, repo:String, path:String, Content:String, filename:String, sha:String)
    case deleteFile(owner:String, repo:String, path:String, filename:String, sha:String)
}

private extension String{
    var URLEscapedString:String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

let GitHubProvider = MoyaProvider<GitHub>(endpointClosure: endpointClosure/*, plugins: [NetworkLoggerPlugin(verbose: true)]*/)

extension GitHub: TargetType{
    
    public var baseURL : URL{
        return URL(string: "https://api.github.com")!
    }
    
    public var path:String{
        switch self {
        case .token(_, _):
            return "/authorizations"
        case .repoSearch(_),
             .trendingReposSinceLastWeek:
            return "/search/repositories"
        case .repo(let owner, let repoName):
            return "/repos\(owner)/\(repoName)"
        case .repoReadMe(let owner, let repoName):
            return "/repos\(owner)/\(repoName)/readme"
        case .pulls(let owner, let repo):
            return "/repos\(owner)/\(repo)/pulls"
        case .issues(let owner, let repo):
            return "/repos\(owner)/\(repo)/issues"
        case .commits(let owner, let repo):
            return "/repos\(owner)/\(repo)/commits"
        case .myRepos:
            return "/user/repos"
        case .readMe(let owner, let repo):
            return "/repos\(owner)/\(repo)/readme"
        case .contents(let owner, let repo, let path):
            return "repos\(owner)/\(repo)/contents/\(path)"
        case .createFile(let owner, let repo, let path, _, let fileName):
            return "/repos\(owner)/\(repo)/contents/\(path)/\(fileName)"
        case .updateFile(let owner, let repo, let path, _, let fileName,_):
            return "/repos\(owner)/\(repo)/contents/\(path)/\(fileName)"
        case .deleteFile(let owner, let repo, let path, let filename, _):
            return "/repos\(owner)/\(repo)/contents/\(path)/\(filename)"
        }
    }
    
    public var method: Moya.Method{
        switch self {
        case .token(_, _):
            return .post
        case .createFile(_,_,_,_,_),
             .updateFile(_,_,_,_,_,_):
            return .put
            
        case .deleteFile(_,_,_,_,_):
            return .delete
            
        case .repoSearch(_),
             .trendingReposSinceLastWeek,
             .repo(_,_),
             .repoReadMe(_,_),
             .pulls(_,_),
             .issues(_,_),
             .commits(_,_),
             .myRepos,
             .readMe(_,_),
             .contents(_, _, _):
        
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
        case .repoSearch(_):
            return StubResponse.fromJSONFile("SearchResponse")
        case .trendingReposSinceLastWeek:
            return StubResponse.fromJSONFile("SearchResponse")
        case .repo(_,_):
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .repoReadMe(_,_):
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .pulls(_,_):
            return "[{\"title\": \"Avatar\", \"user\": { \"login\": \"me\" }, \"createdAt\": \"2011-01-26T19:01:12Z\" }]".data(using: String.Encoding.utf8)!
        case .issues(_,_):
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .commits(_,_):
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .myRepos:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .readMe(_, _),
             .contents(_,_,_),
             .createFile(_,_,_,_,_),
             .updateFile(_,_,_,_,_,_),
             .deleteFile(_,_,_,_,_):
            
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
            
        }
    }
    
    public var task:Task{
        switch self {
        case .token(_, _):
            let params = ["scopes":["public_repo", "user"], "note": "BlogUploader iOS app (\(Date()))"] as [String : Any]
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .repo(_,_),
             .repoReadMe(_,_),
             .pulls,
             .issues,
             .commits,
             .myRepos:
            return .requestPlain
        case .repoSearch(let query):
            let params = ["q": query.URLEscapedString as AnyObject]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .trendingReposSinceLastWeek:
            let params = ["q" : "created:>" + Date().lastWeek(),
                    "sort" : "stars",
                    "order" : "desc"]
             return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .readMe(_, _):
            let params = ["ref":"master"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .contents(_, _, let path):
            let params=["path":path,"ref":"master"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .createFile(_,_, let path,let content,let fileName):
            let params = ["path":"\(path)/\(fileName)", "message":"add file", "content":content, "branch":"master"]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .updateFile(_,_, let path,let content,let fileName, let sha):
            let params = ["path":"\(path)/\(fileName)", "message":"modify file", "content":content, "branch":"master", "sha":sha]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .deleteFile(_,_, let path,let fileName, let sha):
            let params = ["path":"\(path)/\(fileName)", "message":"modify file", "branch":"master", "sha":sha]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
        
     
    }
}

var endpointClosure = {( target:GitHub) -> Endpoint in
    
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let endpoint : Endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200,target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    
    return endpoint
}


