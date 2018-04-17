//
//  MainViewModel.swift
//  blogupdater
//
//  Created by una on 2018. 4. 13..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa

enum MainViewModelResult {
    case query([RepoCellViewModel])
    case queryNothingFound
    case empty
}

class MainViewModel {

    var searchText = BehaviorRelay(value:"")
    
    var selectedItem = PublishSubject<IndexPath>()
    let selectedViewModel : Observable<RepositoryViewModel>
    
    let results : Driver<MainViewModelResult>
    let executing : Driver<Bool>
    let title = "Search"
    
    fileprivate let repoModels : BehaviorRelay<[Repo]>
    fileprivate let provider : MoyaProvider<GitHub>
    
    init(provider : MoyaProvider<GitHub>) {
        
        self.provider = provider
        
        self.executing = BehaviorRelay(value:false).asDriver().distinctUntilChanged()
        let repoModels = BehaviorRelay<[Repo]>(value:[])
        self.repoModels = repoModels
        
        let searchTextObservable = searchText.asObservable()
        let queryResultsObservable = searchTextObservable.throttle(0.3, scheduler: MainScheduler.instance)
            .filter { $0.count > 0 }
            .flatMapLatest { query in
                provider.rx.request(GitHub.repoSearch(query: query))
                    .retry(3)
                    .observeOn(MainScheduler.instance)
            }.mapToModels(Repo.self, arrayRootKey: "items")
            .do(onNext: { (models) in
                repoModels.accept(models)
            })
            .mapToRepoCellViewModel()
            .map { (viewModels) -> MainViewModelResult in
                viewModels.isEmpty ? .queryNothingFound : .query(viewModels)
                
            }.asDriver(onErrorJustReturn: .empty)
        
        let noResultsObservable = searchTextObservable.filter { $0.count == 0}
            .map{_ -> MainViewModelResult in
                .empty
        }.asDriver(onErrorJustReturn: .empty)
        
        results = Driver.of(queryResultsObservable,noResultsObservable).merge()
        
        selectedViewModel = selectedItem.withLatestFrom(repoModels.asObservable()){ indexPath, models in
            models[indexPath.row]
            }.map{model in
                RepositoryViewModel(provider: provider, repo: model)
            }.share(replay: 1, scope: .whileConnected)
        
        
    }
}
