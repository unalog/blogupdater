//
//  RepositoryViewModel.swift
//  blogupdater
//
//  Created by una on 2018. 4. 16..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import SwiftyJSON

class RepositoryViewModel {

    let readMeTaps = PublishSubject<Void>()
    
    var fullName : String{
        return repo.fullName
    }
    
    var description:String{
        return repo.description
    }
    
    var forksCounts:String{
        return String(repo.forks)
    }
    var startsCount:String{
        return String(repo.stargazers)
    }
    
    let readMeUrlObservable : Observable<URL>
    let dataObservable : Driver<[RepositorySectionViewModel]>
    
    fileprivate let provider:MoyaProvider<GitHub>
    fileprivate let repo:Repo
    init(provider:MoyaProvider<GitHub>, repo:Repo) {
        
        self.provider = provider
        self.repo = repo
        
        readMeUrlObservable = readMeTaps.asObservable().flatMap({ (_)  in
            provider.rx.request(GitHub.repoReadMe(owner: repo.owner.name, repoName: repo.fullName)).retry(3).observeOn(MainScheduler.instance)
        })
        .mapJSON()
        .map{
            JSON($0)
        }
            .map({ (json)  in
                URL(string: json["html_url"].stringValue)!
            })
        .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
        
        let lastThreePullsObservers = provider.rx.request(GitHub.pulls(owner: repo.owner.name, repo: repo.fullName)).asObservable()
        .mapToModels(PullRequest.self)
        .asDriver(onErrorJustReturn: [])
        .map { (models:[PullRequest]) -> RepositorySectionViewModel in
            let items = models.prefix(upTo: 3).map{
                RepositoryCellViewModel(title: $0.title, subTitle: $0.author)
            }
            return RepositorySectionViewModel(header: "Last three pull Request", items: items)
        }
            
        let lastTreeIssuesObservable = provider.rx.request(GitHub.issues(owner: repo.owner.name, repo: repo.fullName)).asObservable()
        .mapToModels(Issue.self)
        .asDriver(onErrorJustReturn: [])
            .map { (models:[Issue]) -> RepositorySectionViewModel in
                let item = models.prefix(upTo: 3).map{
                    RepositoryCellViewModel(title: $0.title, subTitle: $0.author)
                }
                return RepositorySectionViewModel(header: "Last three issues", items: item)
        }
        
        let lastTreeCommitObservable = provider.rx.request(GitHub.commits(owner: repo.owner.name, repo: repo.fullName))
        .asObservable()
        .mapToModels(Commit.self)
        .asDriver(onErrorJustReturn: [])
            .map { (models:[Commit]) -> RepositorySectionViewModel in
                let items = models.prefix(upTo: 3).map{
                    RepositoryCellViewModel(title: $0.message, subTitle: $0.author)
                }
                return RepositorySectionViewModel(header: "Last tree commits", items: items)
        }
        
        dataObservable = Driver.zip(lastThreePullsObservers,lastTreeCommitObservable,lastTreeIssuesObservable){
            [$0,$1,$2].filter{!$0.items.isEmpty}
        }
    }
}
struct RepositorySectionViewModel {
    let header:String
    let items:[RepositoryCellViewModel]
}

struct RepositoryCellViewModel {
    let title:String
    let subTitle:String
}
