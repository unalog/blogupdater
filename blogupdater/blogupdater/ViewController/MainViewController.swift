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

    var viewModel:MainViewModel = MainViewModel(provider: GitHubProvider)
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    fileprivate var dataSource = [RepoCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bindToRx()
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

        //performSegue(withIdentifier: "showLogin", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func bindToRx() {
        title = viewModel.title
        searchBar.rx.text.orEmpty.bind(to: viewModel.searchText).disposed(by: disposeBag)
        
        viewModel.results.drive(onNext: { (result) in
            switch result{
            case .query(let cellViewModels):
                self.dataSource = cellViewModels
                self.tableView.reloadData()
            case .empty:
                return
            case .queryNothingFound:
                return
            }
        }).disposed(by: disposeBag)
        
        viewModel.executing.drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible ).disposed(by: disposeBag)
        
    }
    

}
//DataSource

extension MainViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoCell
        
        let rowViewModel = dataSource[indexPath.row]
        cell.configure(rowViewModel.fullName, description: rowViewModel.description, language: rowViewModel.language, stars: rowViewModel.stars)
        
        return cell
    }
}

