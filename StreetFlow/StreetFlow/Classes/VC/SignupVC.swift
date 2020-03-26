//
//  SignupVC.swift
//  StreetFlow
//
//  Created by Alex on 3/18/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
import Parse
import JGProgressHUD

class SignupVC: BaseVC {

    @IBOutlet weak var firstnameLbl: UITextField!
    @IBOutlet weak var lastnameLbl: UITextField!
    @IBOutlet weak var companyLbl: UITextField!
    @IBOutlet weak var phoneLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var pwdLbl: UITextField!
    @IBOutlet weak var forgotLbl: UILabel!
    @IBOutlet weak var termsLbl: UILabel!
    @IBOutlet weak var bottomView: TopRoundView!
    
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
        
        let attributedString2 = NSMutableAttributedString(string: "By checking this box, you agree to our terms of service.")
        attributedString2.addAttribute(.link, value: "terms of service.", range: NSRange(location: 39, length: 17))
        termsLbl.attributedText = attributedString2
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(BaseVC.tapTermsLabel))
        termsLbl.addGestureRecognizer(tap2)
        termsLbl.isUserInteractionEnabled = true
    }
    
    @IBAction func signupBtnAction(_ sender: Any) {
        let user = PFUser()
        user.username = emailLbl.text
        user.email = emailLbl.text
        user.password = pwdLbl.text
        user["first_name"] = firstnameLbl.text
        user["last_name"] = lastnameLbl.text
        user["phone"] = phoneLbl.text
        user["company"] = companyLbl.text
        print(user)
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Sign up..."
        hud.show(in: self.view)
        
        user.signUpInBackground { (success, error) in
            hud.dismiss()
            if success {
                self.goNextVCWithID("PageVC")
            } else {
                let hud2 = JGProgressHUD(style: .dark)
                hud2.textLabel.text = "Sign up error"
                hud2.indicatorView = JGProgressHUDErrorIndicatorView()
                hud2.show(in: self.view)
                hud2.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        self.backVC()
    }
    
}

extension SignupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}
