//
//  LoginViewModel.swift
//  blogupdater
//
//  Created by una on 2018. 4. 12..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class LoginViewModel {
    
    var username = Variable("")
    var password = Variable("")
    
    var loginTaps = PublishSubject<Void>()
    
    let loginEnabled: Driver<Bool>
    let loginFinished: Driver<LoginResult>
    let loginExecuting: Driver<Bool>
    
    fileprivate let provider : MoyaProvider<GitHub>
    
    init(provider:MoyaProvider<GitHub>) {
        self.provider = provider
    
        loginExecuting = Variable(false).asDriver().distinctUntilChanged()
        
        let usernameObservable = username.asObservable()
        let passwordObservable = password.asObservable()
        
        loginEnabled = Observable.combineLatest(usernameObservable, passwordObservable)
        { $0.count > 0 && $1.count > 6 }
            .asDriver(onErrorJustReturn: false)
        
        let usernameAndPassword = Observable.combineLatest(usernameObservable, passwordObservable)
        { ($0, $1) }
        
        
        loginFinished = loginTaps.asObservable()
            .withLatestFrom(usernameAndPassword)
            .flatMapLatest({
                provider.rx.request(GitHub.token(username: $0, password: $1))
                    .retry(3)
                    .asObservable()
                    .observeOn(MainScheduler.instance)
            })
            .mapJSON()
            .do(onNext: { (json) in
//                var appToken = Token()
//                appToken.token = json["token"].string
            }).map({ (json) in
                
//                if let message = json["message"].string {
//                    return LoginResult.field(message: message)
//                } else {
//                    return LoginResult.ok
//                }
//
                return LoginResult.ok
                
            }).asDriver(onErrorJustReturn: LoginResult.field(message: "Oops something went wrong")).debug()
        
        
       
    }

}
