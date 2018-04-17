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
            .mapToModels(ReadMe.self)
            .mapToContentViewCell()
            .asDriver(onErrorJustReturn: [])
            
            
        dataObserver = readMe
        
    }
}


struct ContentViewCell {
    let type:String
    let name:String
    let path:String
}

extension Observable{
    
    func mapToContentViewCell() -> Observable<[ContentViewCell]> {
        return self.map{ data  in
            if let data = data as? [ReadMe] {
                return data.map{ return ContentViewCell(type: $0.type, name: $0.name, path: $0.path) }
            }
            else{
                return []
            }
        }
    }
}
