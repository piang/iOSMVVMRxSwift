//
//  userViewModel.swift
//  iOSMVVMRxSwift
//
//  Created by 洋 裴 on 16/7/18.
//  Copyright © 2016年 玖富集团. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserViewModel: NSObject {
    
    var userModel:PublishSubject<UserModel?>
    
    override init() {
        userModel = PublishSubject()
    }
    
    func loginAction(userName:String, password:String) {
        if (userName == "piang" && password == "123456") {
            
            let tempUserModel = UserModel()
            tempUserModel.userName = userName
            tempUserModel.password = password
            userModel.on(.Next(tempUserModel))
        }
        else {
            userModel.on(.Next(nil))
        }
    }
}
