//
//  LoginVC.swift
//  StreetFlow
//
//  Created by Alex on 3/11/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {

    @IBOutlet weak var bottomViewYConst: NSLayoutConstraint!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var pwdTxtFld: UITextField!
    @IBOutlet weak var bottomView: TopRoundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomView.cornerRadious = 12
        bottomView.layoutIfNeeded()
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        self.goNextVCWithID("PageVC")
    }
    
    @IBAction func signupAction(_ sender: Any) {
        //TODO
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTxtFld {
            self.pwdTxtFld.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
