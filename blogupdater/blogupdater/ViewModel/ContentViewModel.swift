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
    
    let title = "Blog Content"
    
    let dataObserver :Driver<[ContentViewCell]>
    
    init(provider:MoyaProvider<GitHub>, repo:Repo) {
        self.provider = provider
        self.repo = repo
    
    
         let readMe = provider.rx.request(GitHub.readMe(owner: repo.owner.name, repo: repo.fullName))
            .asObservable()
            .mapToModel(ReadMe.self)
            .mapToContentViewCell()
            .asDriver(onErrorJustReturn: [])
        
        
        
          let contents = provider.rx.request(GitHub.contents(owner: repo.owner.name, repo: repo.fullName, path: ""))
            .asObservable()
            .mapToModels(Content.self)
            .mapToContentViewCell()
            .asDriver(onErrorJustReturn: [])
        
        
        dataObserver = Driver.of(readMe,contents).merge()
        
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
            if let data = data as? ReadMe {
                return [ContentViewCell(type: data.type, name: data.name, path: data.path , url : data.htmlUrl) ]
            }
            else if let data = data as? [Content] {
                return data.map{ContentViewCell(type: $0.type, name: $0.name, path: $0.path, url : $0.htmlUrl)}
            }
            else{
                return []
            }
        }
    }
}
