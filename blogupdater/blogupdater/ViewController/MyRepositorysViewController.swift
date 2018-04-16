//
//  MyRepositorysViewController.swift
//  blogupdater
//
//  Created by una on 2018. 4. 16..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyRepositorysViewController: UIViewController {

    var viewModel = MyRepositorysViewModel(provider:GitHubProvider)
    var datasource = [RepoCellViewModel]()
    
    let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bindToRx()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func bindToRx()  {
        
        
        self.title = viewModel.title
        
        viewModel.viewModelResult.drive(onNext: { [weak self] result in
            
            switch result{
                
            case .empty:
                return
            case .repositorys(let cellViewModels):
                self?.datasource = cellViewModels
                self?.tableView.reloadData()
                
            }
        }).disposed(by: disposeBag)
        
        
        
    }
}

extension MyRepositorysViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (datasource.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath)
        let item = datasource[indexPath.row]
        
        cell.textLabel?.text = item.fullName
        cell.detailTextLabel?.text = item.description
        
        return cell;
    }
}
