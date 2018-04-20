//
//  MarkdownEditViewController.swift
//  blogupdater
//
//  Created by una on 2018. 4. 18..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MarkdownEditViewController: UIViewController {

    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var pathLabel: UILabel!
    
    var viewModel : MarkdownEditViewModel?
    let disposeBag = DisposeBag()
    
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
       
        uploadButton.rx.tap.bind(to:vm.uploadTabs).disposed(by: disposeBag)
        
        closeButton.rx.tap.throttle(1.0,scheduler:MainScheduler.instance)
            .subscribe { [weak self] event in
                self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        deleteButton.rx.tap.bind(to:vm.deleteTabs).disposed(by: disposeBag)
        
        vm.deleteResult.drive(onNext: { [weak self](result) in
            switch result{
                
            case .error:
                print("error")
            case .success:
                self?.dismiss(animated: true, completion: nil)
                
            }
        }).disposed(by: disposeBag)
        
       
        
        textView.isEditable = false
        
        vm.loadContent.drive(onNext: { [weak self] (result) in
           
            switch result{
            case .success(let content):
                self?.textView.text = content
                self?.textView.isEditable = true
            case .error:
                self?.textView.isEditable = false
                
            }
        }).disposed(by: disposeBag)
        
        
        
        
        vm.uploadResult.drive(onNext: {[weak self] (result) in
            
            switch result{
            case .success:
                self?.dismiss(animated: true, completion: nil)
            case .error:
                print("error")
            }
        }).disposed(by: disposeBag)
        
        
        textView.rx.text.orEmpty.bind(to:vm.content).disposed(by:disposeBag)
        
        fileNameTextField.text = try? vm.fileName.value()
        fileNameTextField.rx.text.orEmpty.bind(to:vm.fileName).disposed(by: disposeBag)
        
        pathLabel.text = vm.path
       
    }
}
