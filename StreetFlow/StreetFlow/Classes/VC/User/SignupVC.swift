//
//  SignupVC.swift
//  StreetFlow
//
//  Created by Alex on 3/18/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
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
        
//        emailLbl.text = "user22@test.com"
//        pwdLbl.text = "qwerqwer"
//        firstnameLbl.text = "test"
//        lastnameLbl.text = "test"
//        companyLbl.text = "test"
//        phoneLbl.text = "1234567890"
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
        
        let dic = ["email": emailLbl.text!,
                   "password": pwdLbl.text!,
                   "firstname": firstnameLbl.text!,
                   "lastname": lastnameLbl.text!,
                   "company": companyLbl.text!,
                   "phone": phoneLbl.text!]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Sign up..."
        hud.show(in: self.view)
        
        let webService =  RestAPIManager.sharedManager
        webService?.register(dic as [String : Any], callback: { (responseObject:NSDictionary?, error:NSError?) in
            hud.dismiss()
            if((error) != nil){ //error
                if let descrip = error?.localizedDescription{
                    self.showErrorAlert(title: descrip)
                }
            }else{ //success
                self.goNextVCWithID("PageVC")
            }
        })
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
