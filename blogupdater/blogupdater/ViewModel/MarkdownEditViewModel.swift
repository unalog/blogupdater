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
    case modify(url:String)
}

public protocol ContentType{
    var content : String {get}
}

extension MarkdownMode:ContentType{
    var content: String {
        switch self {
        case .new:
            return "new"
        case .modify(_):
            return "modify"
        }
    }
}

class MarkdownEditViewModel{
    
    let mode : MarkdownMode
    
    let provider : MoyaProvider<GitHub>
    let path : String
    var content = BehaviorSubject(value: "")
    let tabUpload = PublishSubject<Void>()
    
    init(mode:MarkdownMode, provider:MoyaProvider<GitHub>, path:String) {
        self.mode = mode
        self.provider = provider
        self.path = path
        
        content.onNext(mode.content)
        
    }
    
}
