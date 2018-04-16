//
//  RepoCellViewModel.swift
//  blogupdater
//
//  Created by una on 2018. 4. 13..
//  Copyright © 2018년 una. All rights reserved.
//

import Foundation
import Moya

class RepoCellViewModel {
    
    let fullName:String
    let description:String
    let language:String
    let stars:String
    
    init(repo:Repo) {
        self.fullName = repo.fullName
        self.description = repo.description
        self.language = repo.language ?? ""
        self.stars = "\(repo.stargazers) stars"
    }
}
