//
//  ContentViewModel.swift
//  blogupdater
//
//  Created by una on 2018. 4. 17..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

class ContentViewModel {

    let provider:MoyaProvider<GitHub>
    let repo:Repo
    let path:String
    
    let title = "Blog Content"
    
    let dataObserver :Driver<[ContentViewCell]>
    
    let selectIndex = PublishSubject<IndexPath>()
    let selectDirViewMode : Observable<ContentViewModel>
    let selectFileViewModel : Observable<ContentViewCell>
    
    init(provider:MoyaProvider<GitHub>, repo:Repo, path:String) {
        self.provider = provider
        self.repo = repo
        self.path = path
          dataObserver = provider.rx.request(GitHub.contents(owner: repo.owner.name, repo: repo.fullName, path: path))
            .asObservable()
            .mapToModels(Content.self)
            .map{
                $0.filter({ content -> Bool in
                    if content.type == "dir"{
                        if content.name == "public" , path == ""{
                            return false
                        }
                        else  if content.name == "css" , path == ""{
                            return false
                        }
                        else if content.name == "_posts" {
                            return true
                        }
                        else if content.name.hasPrefix("."){
                            return false
                        }
                        else if content.name.hasPrefix("_"){
                            return false
                        }
                        else{
                            return true
                        }
                    }
                    else if content.type == "file"{
                        return content.name.hasSuffix(".md")
                    }
                    else{
                        return false
                    }
                })
            }
            .mapToContentViewCell()
            .asDriver(onErrorJustReturn: [])
        
        let selectViewMode = selectIndex.withLatestFrom(dataObserver) { (indexPath, contents) -> ContentViewCell in
            contents[indexPath.row]
        }
        
        selectDirViewMode = selectViewMode.filter({ (vm) -> Bool in
            return !vm.path.hasSuffix(".md")
        }).map({ (contentViewCell) -> ContentViewModel in
            return ContentViewModel(provider: provider, repo: repo, path: contentViewCell.path)
        })
        
        selectFileViewModel = selectViewMode.filter({ (vm) -> Bool in
            return vm.path.hasSuffix("md")
        }).map({ (contentViewCell) -> ContentViewCell in
            return ContentViewCell(type: contentViewCell.type, name: contentViewCell.name, path: contentViewCell.path, url: contentViewCell.url)
        })
        
    }
}


struct ContentViewCell {
    let type:String
    let name:String
    let path:String
    let url:String
}

extension Observable{
    
    func mapToContentViewCell() -> Observable<[ContentViewCell]> {
        return self.map{ data  in
           if let data = data as? [Content] {
                return data.map{ContentViewCell(type: $0.type, name: $0.name, path: $0.path, url : $0.htmlUrl)}
            }
            else{
                return []
            }
        }
    }
}
