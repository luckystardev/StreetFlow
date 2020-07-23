//
//  LoginVC.swift
//  StreetFlow
//
//  Created by Alex on 3/11/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
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
//        emailTxtFld.text = "mob@test.com"
//        pwdTxtFld.text = "qwerqwer"
//        self.updateFullname("LIEN KIEN;CHEN TRACY")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomView.cornerRadious = 12
        bottomView.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)),
        name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
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
        
        let webService =  RestAPIManager.sharedManager
        webService?.login(emailTxtFld.text!, password: pwdTxtFld.text!, callback: { (responseObject:NSDictionary?, error:NSError?) in
            hud.dismiss()
            if((error) != nil){ //error
                if let descrip = error?.localizedDescription{
                    self.showErrorAlert(title: descrip)
                }
            }else{ //success
                self.getMe()
            }
        })
    }
    
    func getMe() {
        let webService =  RestAPIManager.sharedManager
        webService?.getUserInfo(callback: { (responseObject:NSDictionary?, error:NSError?) in
            if((error) != nil){ //error
                if let descrip = error?.localizedDescription{
                    self.showErrorAlert(title: descrip)
                }
            }else{ //success
                print("success")
                self.goNextVCWithID("PageVC")
            }
        })
    }
    
    @IBAction func signupAction(_ sender: Any) {
        //No need this function
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.bottomViewYConst?.constant = 0.0
            } else {
                self.bottomViewYConst?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
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
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return true
//    }
}
