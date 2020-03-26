//
//  LoginVC.swift
//  StreetFlow
//
//  Created by Alex on 3/11/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
import Parse
import JGProgressHUD

class LoginVC: BaseVC {

    @IBOutlet weak var bottomViewYConst: NSLayoutConstraint!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var pwdTxtFld: UITextField!
    @IBOutlet weak var bottomView: TopRoundView!
    @IBOutlet weak var forgotLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applyAttributedString()
        
        //This is test code
        emailTxtFld.text = "q@q.com"
        pwdTxtFld.text = "qwerqwer"
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
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Log in..."
        hud.show(in: self.view)
        
        PFUser.logInWithUsername(inBackground: emailTxtFld.text!, password: pwdTxtFld.text!) { (user, error) in
            hud.dismiss()
            if user != nil {
                self.goNextVCWithID("PageVC")
            } else {
                if let descrip = error?.localizedDescription{
                    let hud2 = JGProgressHUD(style: .dark)
                    hud2.textLabel.text = descrip
                    hud2.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud2.show(in: self.view)
                    hud2.dismiss(afterDelay: 2.0)
                }
            }
        }
    }
    
    @IBAction func signupAction(_ sender: Any) {
        //No need this function
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
