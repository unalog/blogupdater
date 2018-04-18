//
//  MarkdownEditViewModel.swift
//  blogupdater
//
//  Created by una on 2018. 4. 18..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class MarkdownEditViewModel {
    
    let provider : MoyaProvider<GitHub>
    let path : String
    
    init(provider:MoyaProvider<GitHub>, path:String) {
        self.provider = provider
        self.path = path
    }
}
