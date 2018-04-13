//
//  MainViewController.swift
//  blogupdater
//
//  Created by una on 2018. 4. 13..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class MainViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var provider : MoyaProvider<GitHub>!
    var lastestRepositiryName:Observable<String>{
        
        return searchBar.rx.text.orEmpty
            .debounce(0.5, scheduler:MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupRx()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        let appToken = Token()
        
        if appToken.tokenExists ==  false{
            
            performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupRx() {
        provider = MoyaProvider<GitHub>()
        
        tableView.rx.itemSelected.asObservable()
            .subscribe(onNext: { indexPath in
                if self.searchBar.isFirstResponder == true{
                    self.view.endEditing(true)
                }
            }).disposed(by: disposeBag)
    }

}
