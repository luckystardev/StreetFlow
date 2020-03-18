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
    @IBOutlet weak var forgotLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyAttributedString()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomView.cornerRadious = 12
        bottomView.layoutIfNeeded()
    }
    
    func applyAttributedString() {
        let attributedString = NSMutableAttributedString(string: "Forgot ID or Password? Reset")
        attributedString.addAttribute(.link, value: "Reset", range: NSRange(location: 23, length: 5))
        forgotLbl.attributedText = attributedString
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseVC.tapForgotLabel))
        forgotLbl.addGestureRecognizer(tap)
        forgotLbl.isUserInteractionEnabled = true
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
