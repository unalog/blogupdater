//
//  ContentViewController.swift
//  blogupdater
//
//  Created by una on 2018. 4. 17..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import Moya
import RxCocoa
import RxSwift

class ContentViewController: UIViewController {

    var provider:MoyaProvider<GitHub>?
    var viewModel:ContentViewModel?
    var dataSource=[ContentViewCell]()
    
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
        guard let vm = viewModel else {
            return
        }
        
        self.title = vm.title
        
        vm.dataObserver.drive(onNext: { [weak self] datas in
            self?.dataSource = datas
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
    }
}

extension ContentViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath)
        let item = dataSource[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
}
