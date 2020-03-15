//
//  SearchVC.swift
//  StreetFlow
//
//  Created by Alex on 3/12/20.
//  Copyright © 2020 ClubA. All rights reserved.
//

import UIKit

class SearchVC: BaseVC {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var locationView: RoundView!
    @IBOutlet weak var searchFld: UITextField!
    @IBOutlet weak var bottomMenuBtn: UIButton!
    
    @IBOutlet weak var bottomViewConst: NSLayoutConstraint!
    var index = 0
    
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
        self.index = 2
        self.tableview.reloadData()
        
        return true
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! ListCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popNextVCWithID("DealVC", isFull: false)
    }
    
}
