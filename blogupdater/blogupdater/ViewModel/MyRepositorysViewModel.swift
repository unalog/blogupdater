//
//  MyRepositorysViewModel.swift
//  blogupdater
//
//  Created by una on 2018. 4. 16..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

enum viewModelResult {
    case empty
    case repositorys([RepoCellViewModel])
}

class MyRepositorysViewModel {
    
    
    let title:String
    let provider :MoyaProvider<GitHub>
    
    let viewModelResult :Driver<viewModelResult>
    var repoModels :BehaviorRelay<[Repo]>
    
    init(provider:MoyaProvider<GitHub>) {
    
        self.title = "My Repositorys"
        self.provider = provider
        
        let repoModels = BehaviorRelay<[Repo]>(value: [])
        self.repoModels = repoModels
        
        viewModelResult = provider.rx.request(GitHub.myRepos).asObservable()
            .mapToModels(Repo.self)
            .do(onNext: { (models) in
                repoModels .accept(models)
            })
            .mapToRepoCellViewModel()
            .map { (viewModels) -> viewModelResult in
                viewModels.isEmpty ? .empty : .repositorys(viewModels)
                
            }.asDriver(onErrorJustReturn: .empty)
        
        
        
        
    }
}
