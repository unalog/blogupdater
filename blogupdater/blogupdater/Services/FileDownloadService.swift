//
//  FileDownloadService.swift
//  blogupdater
//
//  Created by una on 2018. 4. 19..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import Moya


enum FileDownload {
    case download(url:String, fileName:String)
}

extension FileDownload : TargetType{
    
    var baseURL: URL {
        switch self {
        case .download(let url,_):
            return URL(string:url)!
       
        }
    }
    
    var path: String {
        switch self {
        case .download(_,_):
            return ""
        }
    }
    
    var method: Moya.Method {
        
        switch self {
        case .download(_,_):
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "default data".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .download(_,_):
            return .downloadDestination(DefaultDownloadDestination)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}

private let DefaultDownloadDestination: DownloadDestination = { temporaryURL, response in
    
    let documentsURL = FileSystem.downloadDirectory
    let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
    
    print(fileURL)
    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    
}

let fileDownloadEndpointClosure={ (target:TargetType) -> Endpoint in
    let url = target.baseURL.absoluteString
    
    return Endpoint(url: url, sampleResponseClosure: { .networkResponse(200, target.sampleData) }, method: target.method, task: target.task, httpHeaderFields: target.headers)
    
}

let fileDownloadProvider = MoyaProvider<FileDownload>(endpointClosure: fileDownloadEndpointClosure, plugins: [NetworkLoggerPlugin(verbose: true)])


class FileSystem {
    static let documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    static let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    static let downloadDirectory: URL = {
        let directory: URL = FileSystem.documentsDirectory.appendingPathComponent("/Download/")
        return directory
    }()
    
}

