//
//  ResetPwdVC.swift
//  StreetFlow
//
//  Created by Alex on 7/15/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
import JGProgressHUD

class ResetPwdVC: BaseVC {

    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var bottomView: TopRoundView!
    @IBOutlet weak var bottomViewYConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bottomView.cornerRadious = 12
        bottomView.layoutIfNeeded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)),
        name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = ""
        hud.show(in: self.view)
        
        let webService =  RestAPIManager.sharedManager
        webService?.forgotPassword(emailFld.text!, callback: { (responseObject:NSDictionary?, error:NSError?) in
            hud.dismiss()
            if((error) != nil){ //error
                if let descrip = error?.localizedDescription{
                    self.showErrorAlert(title: descrip)
                }
            }else{ //success
                self.goNextVCWithID("ConfirmVC")
            }
        })
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        self.backLoginVC()
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

extension ResetPwdVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
