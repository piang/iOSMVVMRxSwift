//
//  ViewController.swift
//  iOSMVVMRxSwift
//
//  Created by 洋 裴 on 16/5/23.
//  Copyright © 2016年 玖富集团. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let minimalUsernameLength = 5
let minimalPasswordLength = 5

class ViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    var userViewModel = UserViewModel()
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let userNameValid = userNameTextField.rx_text.map{
            $0.characters.count >= minimalUsernameLength
            }.shareReplay(1)
        let passwordValid = passwordTextField.rx_text.map{
            $0.characters.count >= minimalPasswordLength
            }.shareReplay(1)
        
        let everythingValid = Observable.combineLatest(userNameValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
        everythingValid.bindTo(loginButton.rx_enabled).addDisposableTo(disposeBag)
        
        everythingValid.subscribeNext { [weak self] Bool in
            if (Bool) {
                self?.loginButton.backgroundColor = UIColor.redColor()
            }
            else {
                self?.loginButton.backgroundColor = UIColor.lightGrayColor()
            }
        }.addDisposableTo(disposeBag)
        
        self.loginButton.rx_tap.subscribeNext { [weak self] _ in
            self?.userViewModel.loginAction((self?.userNameTextField.text)!, password: (self?.passwordTextField.text)!)
        }.addDisposableTo(disposeBag)
        
        self.userViewModel.userModel.subscribeNext({ UserModel in
            if (UserModel == nil) {
                print("登录失败")
            }
            else {
                print("登录成功")
            }
        }).addDisposableTo(disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

