//
//  SearchVC.swift
//  StreetFlow
//
//  Created by Alex on 3/12/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit
import JGProgressHUD

class SearchVC: BaseVC {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var locationView: RoundView!
    @IBOutlet weak var searchFld: UITextField!
    @IBOutlet weak var bottomMenuBtn: UIButton!
    
    @IBOutlet weak var bottomViewConst: NSLayoutConstraint!
    var index = 0
    var isSuccess = false
    var info: [String : String?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.searchFld.becomeFirstResponder()
    }
    
    @IBAction func bottomMenuBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func downBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if bottomViewConst.constant == 0 {
                bottomViewConst.constant = keyboardSize.height + 10
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if bottomViewConst.constant != 0 {
            bottomViewConst.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let hud = JGProgressHUD(style: .dark)
//        hud.textLabel.text = ""
//        hud.show(in: self.view)
        
        self.getEstatedInfo(textField.text!) { (flag, result) in
//            hud.dismiss()
            if !flag {
                print("failed!!!")
                DispatchQueue.main.async {
                    let hud2 = JGProgressHUD(style: .dark)
                    hud2.textLabel.text = result
                    hud2.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud2.show(in: self.view)
                    hud2.dismiss(afterDelay: 2.0)
                }
            } else {
                print("success!!!")
                self.isSuccess = true
                DispatchQueue.main.async {
                    self.info = self.getbasicInfo()
                    if self.info?["name"] != "" {
                        self.index = 1
                        self.tableview.reloadData()
                    }
                }
            }
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! ListCell
        var ownerStr = info?["name"] ?? ""
        ownerStr = ownerStr?.replacingOccurrences(of: ";", with: ", ")
        cell.nameLbl.text = ownerStr
        cell.streetLbl.text = info?["formatted_street_address"] ?? ""
        let city : String = (info?["city"] ?? "") ?? " "
        let state : String = (info?["state"] ?? "") ?? " "
        let zip_code : String = (info?["zip_code"] ?? "") ?? " "
        let address : String = city + ", " + state + " " + zip_code
        cell.addressLbl.text = address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popNextVCWithID("DealVC", isFull: false)
    }
    
}
