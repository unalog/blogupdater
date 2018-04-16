//
//  RepoCellTableViewCell.swift
//  blogupdater
//
//  Created by una on 2018. 4. 13..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import RxSwift

class RepoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak fileprivate var descriptionLabel: UILabel!
    @IBOutlet weak fileprivate var languageLabel: UILabel!
    @IBOutlet weak fileprivate var starsLabel: UILabel!
    
    
    func configure(_ title: String, description: String, language: String, stars: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        languageLabel.text = language
        starsLabel.text = stars
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension Observable{
    func maptoRepoCellViewModel() -> Observable<[RepoCellViewModel]> {
        return self.map{ repos in
            if let repos = repos as? [Repo]{
                return repos.map{return RepoCellViewModel(repo: $0)}
            }else{
                return []
            }
        }
    }
}
