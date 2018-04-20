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

enum DownloadResult {
    case error
    case success(content:String)
}
enum UploadResult {
    
    case error
    case success
}

enum MarkdownMode{
    case new(name:String)
    case modify(url:String, name:String)
}

public protocol ContentType{
    var content : String {get}
}

extension MarkdownMode:ContentType{
    
   
    internal var content: String {
        switch self {
        case .new(let name):
            
            Bundle.main.path(forResource: name.fileName(), ofType: name.fileExtension())
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
    
    var name:String {
        
        switch self {
        case .new(_):
            return String.mdFileName()
        case .modify(_,let name):
            return name
        }
    }
}

class MarkdownEditViewModel{
    
    let mode : MarkdownMode
    let provider : MoyaProvider<GitHub>
    let path : String
    let repo:Repo
    let disposeBag = DisposeBag()
    
    var loadContent :Driver<DownloadResult>
    var uploadResult:Driver<UploadResult>
    var fileName = BehaviorSubject(value: "")
    
    let content = BehaviorRelay(value: "")
    let uploadTabs = PublishSubject<Void>()
    
    
    init(mode:MarkdownMode, provider:MoyaProvider<GitHub>, path:String, repo:Repo) {
        
        self.mode = mode
        self.provider = provider
        self.path = path
       
        self.fileName.onNext(mode.name)
        self.repo = repo

        
        switch mode {
            
        case .modify(let url,let name):

            loadContent = fileDownloadProvider.rx.request(FileDownload.download(url:url, fileName: name))
                .observeOn(MainScheduler.instance)
                .map({ (response) -> DownloadResult in
                    DownloadResult.success(content: mode.content)
                })
                .asDriver(onErrorJustReturn: .error)
            uploadResult = Driver.of(.error)

        case .new(_):

            loadContent = Observable.just(mode.content)
                .map({ (string) -> DownloadResult in
                    DownloadResult.success(content: string)
                }).asDriver(onErrorJustReturn: .error)
            
            let contentObserver = content.asObservable()
            let nameObserver = fileName.asObservable()
            let namecontentObserver = Observable.combineLatest(nameObserver,contentObserver)
            
            uploadResult = uploadTabs.asObservable()
            
                .withLatestFrom(namecontentObserver)
                .flatMapLatest({ (name, content) -> Observable<Response> in
                    return provider.rx.request(GitHub.createFile(owner: repo.owner.name, repo: repo.fullName, path: path, content: content.toBase64(), filename:name ))
                        .retry(3)
                        .asObservable()
                        .observeOn(MainScheduler.instance)
                })
                
                .mapToModel(EditContentResult.self)
                .map({ (result) -> UploadResult in
                    .success
                })
                .asDriver(onErrorJustReturn: .error)

        }
        
    }
    
}

extension String {
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
    
    static func mdFileName() -> String {
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        var dateString = dateFormatter.string(from: date)

        dateString.append("-fileName.md")

        return dateString
    }
}

