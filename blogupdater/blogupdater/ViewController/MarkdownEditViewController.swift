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

    var viewModel : MarkdownEditViewModel?
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var fileNameTextField: UITextField!
    
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
        
        closeButton.rx.tap.throttle(1.0,scheduler:MainScheduler.instance)
            .subscribe { [weak self] event in
                self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        
        textView.isEditable = false
        
        vm.content.subscribe(onNext: { [weak self] text in
            self?.textView.isEditable = true
            self?.textView.text = text
        }).disposed(by: disposeBag)
        
        textView.rx.text.orEmpty.bind(to:vm.content).disposed(by:disposeBag)
        
        
        
        
    }
}
