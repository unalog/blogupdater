//
//  MarkdownEditViewModel.swift
//  blogupdater
//
//  Created by una on 2018. 4. 18..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

enum MarkdownMode{
    case new
    case modify(url:String, name:String)
}

public protocol ContentType{
    var content : String {get}
}

extension MarkdownMode:ContentType{
    var content: String {
        switch self {
        case .new:
            
            guard let path = Bundle.main.path(forResource: "post_mark_down", ofType: "md") else {
                return "path null"
            }
            
            do {
                return try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            } catch _ as NSError {
                return "error"
            }
            
        case .modify(_,let name):
            
            let documentsURL = FileSystem.downloadDirectory
            let fileURL = documentsURL.appendingPathComponent(name)
            
            guard let file = try? FileHandle(forReadingFrom: fileURL) else { return "error"}
            
            let databuffer = file.readDataToEndOfFile()
            let out: String = String(data:databuffer, encoding:String.Encoding.utf8)!
            file.closeFile()
            
            return out
            
        }
    }
}

class MarkdownEditViewModel{
    
    let mode : MarkdownMode
    
    let provider : MoyaProvider<GitHub>
    let path : String
    let name : String
    var content = BehaviorSubject(value: "")
    let tabUpload = PublishSubject<Void>()
    
    init(mode:MarkdownMode, provider:MoyaProvider<GitHub>, path:String, name :String) {
        self.mode = mode
        self.provider = provider
        self.path = path
        self.name = name
        
       
        switch mode{
        case .new:
            content.onNext(mode.content)
        case .modify(let url, let name):
            fileDownloadProvider.request(FileDownload.download(url: url, fileName: name)) { [weak self] (result) in
                self?.content.onNext(mode.content)
            }
        }
        
    }
    
}
