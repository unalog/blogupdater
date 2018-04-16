//
//  RepositoryViewController.swift
//  blogupdater
//
//  Created by una on 2018. 4. 16..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SafariServices

class RepositoryViewController: UIViewController {

    var viewModel :RepositoryViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var startCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var readMeButton: UIButton!
    
    fileprivate var datasource = [RepositorySectionViewModel]()
    fileprivate let disposeBag = DisposeBag()
    
    
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

    func bindToRx() {
        
        guard let vm = viewModel else{ return }
        
        title = vm.fullName
        titleLabel.text = vm.fullName
        descriptionLabel.text = vm.description
        forkCountLabel.text = vm.forksCounts
        startCountLabel.text = vm.startsCount
        
        readMeButton.rx.tap.bind(to:vm.readMeTaps).disposed(by: disposeBag)
        
        vm.readMeUrlObservable.subscribe(onNext: {[weak self] url in
            let svc = SFSafariViewController(url: url)
            self?.present(svc, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
        vm.dataObservable.drive(onNext: { [weak self] data in
            self?.datasource = data
            self?.tableView.reloadData()
        }).disposed(by:disposeBag)
    }
   
}


extension RepositoryViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasource[section].header
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath)
        let item = datasource[indexPath.section].items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subTitle
        
        return cell
    }
    

}
