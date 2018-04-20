//
//  LoginViewController.swift
//  blogupdater
//
//  Created by una on 2018. 4. 12..
//  Copyright © 2018년 una. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    var viewModel = LoginViewModel(provider: GitHubProvider)
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
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
        
        userNameTextField.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        
        loginButton.rx.tap.bind(to:viewModel.loginTaps).disposed(by: disposeBag)
        
        viewModel.loginEnabled.drive(loginButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.loginExecuting.drive(onNext: { (excuting) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = excuting
        }).disposed(by: disposeBag)
        
        viewModel.loginFinished.drive(onNext: { (result) in
            switch result{
            case .field(let message):
                let  alert = UIAlertController(title:"Opps!", message:message, preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    
                }))
                self.present(alert,animated: true,completion: nil)
            case .ok:
                self.dismiss(animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
        
        
    }

}

extension LoginViewController{
    
    fileprivate func customizeLoginButton(){
        loginButton.layer.cornerRadius = 6.0
        loginButton.layer.masksToBounds = true
    }
}
